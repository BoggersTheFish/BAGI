//! # bos-kernel — TS (Thinking System) scheduler stubs
//!
//! **TS** here means **Thinking System / Thinking Wave** (constraint-graph cognition),
//! **not** TypeScript.
//!
//! ## Intended integration (future waves)
//! - Redox-style microkernel: <https://github.com/redox-os/redox>
//! - Idle task = one graph tick: `propagate` → `relax` → tension check → `break_weak` / `evolve`.
//! - Ring buffer for tension telemetry (userspace dashboard).

/// Golden ratio φ — used for φ-resonant tick scaling (UI/kernel scheduling experiments).
pub const PHI: f64 = 1.618_033_988_749_895;

/// Minimal node state for future UniversalLivingGraph ↔ VFS mapping.
#[derive(Clone, Debug, Default)]
pub struct TsNodeState {
    pub activation: f64,
    pub base_strength: f64,
    pub stability: f64,
}

impl TsNodeState {
    /// Relax(): decay activation toward `base_strength` (rate 0.05 per spec).
    pub fn relax(&mut self) {
        let rate = 0.05;
        self.activation += rate * (self.base_strength - self.activation);
    }
}

/// One topological + semantic propagation step (depth ≥ 3 in full kernel; stub = local blend).
pub fn propagate_stub(n: &mut TsNodeState, neighbor_avg_activation: f64) {
    let alpha = 0.7;
    n.activation = alpha * n.activation + (1.0 - alpha) * neighbor_avg_activation;
    n.activation = n.activation.clamp(0.0, 1.0);
}

/// Tension scalar (higher = more conflict). Stub uses distance from neutral band.
pub fn tension_stub(nodes: &[TsNodeState]) -> f64 {
    if nodes.is_empty() {
        return 0.0;
    }
    let mean: f64 = nodes.iter().map(|n| n.activation).sum::<f64>() / nodes.len() as f64;
    let var: f64 = nodes
        .iter()
        .map(|n| (n.activation - mean).powi(2))
        .sum::<f64>()
        / nodes.len().max(1) as f64;
    (var.sqrt() + (mean - 0.5).abs()).min(1.0)
}

/// Single TS “tick”: propagate (stub) → relax → return tension.
pub fn ts_idle_tick(nodes: &mut [TsNodeState], neighbor_avg: f64) -> f64 {
    for n in nodes.iter_mut() {
        propagate_stub(n, neighbor_avg);
        n.relax();
    }
    tension_stub(nodes)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn relax_moves_toward_base() {
        let mut n = TsNodeState {
            activation: 1.0,
            base_strength: 0.5,
            stability: 0.9,
        };
        n.relax();
        assert!(n.activation < 1.0);
    }
}
