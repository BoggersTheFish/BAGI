//! **TS** = Thinking System / Thinking Wave (constraint-graph cognition) — **not** TypeScript.
//!
//! Kernel idle integration: call [`ts_idle_tick_full`] from the Redox scheduler idle path
//! after this crate is linked into `kernel` (see `docs/REDOX_KERNEL_HOOK.md`).
//!
//! References: [GOAT-TS](https://github.com/BoggersTheFish/GOAT-TS), [PMC10181851](https://pmc.ncbi.nlm.nih.gov/articles/PMC10181851/) (φ / EEG context per project spec).

#![no_std]

use libm::sqrtf;

/// Golden ratio φ — scheduling / layout resonance constant.
pub const PHI: f32 = 1.618_034;

/// Tension threshold for Break() — spec > 0.85
pub const TENSION_BREAK: f32 = 0.85;

/// Relax decay rate toward `base_strength`.
pub const RELAX_RATE: f32 = 0.05;

/// Max nodes in the kernel-side graph slice (inode/cluster stand-in).
pub const MAX_NODES: usize = 64;

/// Topological + cosine-style propagation depth (3 steps).
pub const PROPAGATE_DEPTH: usize = 3;

#[derive(Clone, Copy, Debug, Default)]
pub struct TsNodeState {
    pub activation: f32,
    pub base_strength: f32,
    pub stability: f32,
}

impl TsNodeState {
    /// Relax(): decay activation toward base_strength.
    #[inline]
    pub fn relax(&mut self) {
        self.activation += RELAX_RATE * (self.base_strength - self.activation);
        if self.activation > 1.0 {
            self.activation = 1.0;
        }
        if self.activation < 0.0 {
            self.activation = 0.0;
        }
    }
}

/// Ring buffer for tension telemetry (userspace dashboard via syscall later).
#[derive(Clone, Copy, Debug)]
pub struct TensionRing<const N: usize> {
    pub buf: [f32; N],
    pub head: usize,
    pub len: usize,
}

impl<const N: usize> TensionRing<N> {
    pub const fn new() -> Self {
        Self {
            buf: [0.0; N],
            head: 0,
            len: 0,
        }
    }

    pub fn push(&mut self, t: f32) {
        self.buf[self.head] = t;
        self.head = (self.head + 1) % N;
        if self.len < N {
            self.len += 1;
        }
    }

    pub fn last(&self) -> f32 {
        if self.len == 0 {
            return 0.0;
        }
        let idx = (self.head + N - 1) % N;
        self.buf[idx]
    }
}

/// Propagate activation along abstract edges for `depth` steps (stub: local diffusion).
fn propagate_layers(nodes: &mut [TsNodeState], count: usize, depth: usize) {
    let n = count.min(MAX_NODES);
    for _ in 0..depth {
        let mut tmp = [0.0f32; MAX_NODES];
        for i in 0..n {
            let prev = if i > 0 { i - 1 } else { n - 1 };
            let next = if i + 1 < n { i + 1 } else { 0 };
            let avg = (nodes[prev].activation + nodes[next].activation) * 0.5;
            tmp[i] = 0.7 * nodes[i].activation + 0.3 * avg;
        }
        for i in 0..n {
            nodes[i].activation = tmp[i].clamp(0.0, 1.0);
        }
    }
}

/// Cosine similarity proxy on two scalars (kernel-friendly; full embedding in userspace).
#[inline]
fn cosine_proxy(a: f32, b: f32) -> f32 {
    let denom = sqrtf(a * a + b * b) + 1e-6;
    (a * b) / denom
}

/// Tension from activation spread + φ-weighted mismatch.
pub fn compute_tension(nodes: &[TsNodeState], count: usize) -> f32 {
    let n = count.min(MAX_NODES);
    if n == 0 {
        return 0.0;
    }
    let mut mean = 0.0f32;
    for i in 0..n {
        mean += nodes[i].activation;
    }
    mean /= n as f32;
    let mut var = 0.0f32;
    for i in 0..n {
        let d = nodes[i].activation - mean;
        var += d * d;
    }
    var /= n as f32;
    let cos_term = cosine_proxy(mean, PHI - 1.0); // φ-resonance anchor
    (sqrtf(var) + (1.0 - cos_term).abs() * 0.1).min(1.0)
}

/// Break weakest cluster: remove node with lowest stability (in-place compact).
pub fn break_weakest(nodes: &mut [TsNodeState], count: &mut usize) {
    let n = *count;
    if n <= 1 {
        return;
    }
    let mut wi = 0usize;
    let mut ws = f32::MAX;
    for i in 0..n {
        if nodes[i].stability < ws {
            ws = nodes[i].stability;
            wi = i;
        }
    }
    for j in wi..n - 1 {
        nodes[j] = nodes[j + 1];
    }
    nodes[n - 1] = TsNodeState::default();
    *count -= 1;
}

/// Evolve: placeholder for QLoRA hot-swap / stronger node promotion (no alloc here).
#[inline]
pub fn evolve_stub(nodes: &mut [TsNodeState], count: usize) {
    let n = count.min(MAX_NODES);
    for i in 0..n {
        nodes[i].stability = (nodes[i].stability + 0.01 * nodes[i].activation).min(1.0);
    }
}

/// **Full TS idle tick** — Propagate (depth 3) → Relax → Tension → Break if needed → Evolve.
pub fn ts_idle_tick_full(
    nodes: &mut [TsNodeState; MAX_NODES],
    count: &mut usize,
    ring: &mut TensionRing<256>,
    empty_peace: bool,
) -> f32 {
    let n = (*count).min(MAX_NODES);
    if empty_peace {
        for i in 0..n {
            nodes[i].activation = nodes[i].activation * 0.9 + nodes[i].base_strength * 0.1;
        }
    }
    propagate_layers(nodes, n, PROPAGATE_DEPTH);
    for i in 0..n {
        nodes[i].relax();
    }
    let mut t = compute_tension(nodes, n);
    if t > TENSION_BREAK {
        break_weakest(nodes, count);
        t = compute_tension(nodes, *count);
    }
    evolve_stub(nodes, *count);
    ring.push(t);
    t
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn tick_runs() {
        let mut nodes = [TsNodeState::default(); MAX_NODES];
        nodes[0] = TsNodeState {
            activation: 0.9,
            base_strength: 0.5,
            stability: 0.9,
        };
        nodes[1] = TsNodeState {
            activation: 0.2,
            base_strength: 0.5,
            stability: 0.9,
        };
        let mut count = 2usize;
        let mut ring = TensionRing::<256>::new();
        let t = ts_idle_tick_full(&mut nodes, &mut count, &mut ring, false);
        assert!(t >= 0.0 && t <= 1.0);
    }
}
