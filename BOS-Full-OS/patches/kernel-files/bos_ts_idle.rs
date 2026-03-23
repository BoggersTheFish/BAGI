//! BOS — TS (Thinking System / Thinking Wave) kernel idle hook.
//! **Not** TypeScript. Web UI only: <https://www.typescriptlang.org/docs/>
//!
//! Call `ts_kernel_idle_hook()` from the scheduler idle path (`INJECT-POINTS.md`).
//! Wave 065: on x86_64, COM1 emits `TS_IDLE_TICK_RUNNING` periodically for
//! `scripts/test-boot.sh` (QEMU `-serial file:` / stdio capture).

use bos_ts_kernel::{ts_idle_tick_full, TsNodeState, TensionRing, MAX_NODES};

static mut TS_NODES: [TsNodeState; MAX_NODES] = [TsNodeState::default(); MAX_NODES];
static mut TS_COUNT: usize = 0;
static mut TS_RING: TensionRing<256> = TensionRing::new();
static mut EMPTY_PEACE: bool = false;
static mut TS_IDLE_TICKS: u64 = 0;

/// Invoke once per idle quantum (Redox scheduler).
#[inline]
pub unsafe fn ts_kernel_idle_hook() {
    ts_idle_tick_full(
        &mut TS_NODES,
        &mut TS_COUNT,
        &mut TS_RING,
        EMPTY_PEACE,
    );
    TS_IDLE_TICKS = TS_IDLE_TICKS.wrapping_add(1);
    #[cfg(target_arch = "x86_64")]
    {
        ts_emit_serial_marker_if_due();
    }
}

pub unsafe fn set_empty_peace(enabled: bool) {
    EMPTY_PEACE = enabled;
}

pub unsafe fn last_tension() -> f32 {
    TS_RING.last()
}

// --- Wave 065: QEMU serial line for boot verification (x86_64 COM1) ---

#[cfg(target_arch = "x86_64")]
const SERIAL_MARKER: &[u8] = b"TS_IDLE_TICK_RUNNING\n";

#[cfg(target_arch = "x86_64")]
#[inline(never)]
unsafe fn ts_emit_serial_marker_if_due() {
    const INTERVAL: u64 = 512;
    if TS_IDLE_TICKS % INTERVAL != 0 {
        return;
    }
    bos_ts_serial_write_bytes(SERIAL_MARKER);
}

#[cfg(target_arch = "x86_64")]
unsafe fn bos_ts_serial_write_bytes(buf: &[u8]) {
    for &byte in buf {
        while (x86_inb(0x3FD) & 0x20) == 0 {}
        x86_outb(0x3F8, byte);
    }
}

#[cfg(target_arch = "x86_64")]
unsafe fn x86_inb(port: u16) -> u8 {
    let v: u8;
    core::arch::asm!("in al, dx", out("al") v, in("dx") port, options(nomem, nostack));
    v
}

#[cfg(target_arch = "x86_64")]
unsafe fn x86_outb(port: u16, val: u8) {
    core::arch::asm!("out dx, al", in("dx") port, in("al") val, options(nomem, nostack));
}
