//! BOS **TS-OS** Orbital desktop — **Thinking System** live graph (not TypeScript).
//! Optional web UI bridge: <https://www.typescriptlang.org/docs/>
//!
//! Wave 065: φ-scaled “Cytoscape-style” graph as the main surface, top tension strip
//! (mirrors `TensionRing` via `bos_ts_kernel::ts_idle_tick_full` in userspace until kernel IPC),
//! Root Node Controls (Empty Peace + φ-resonance). Literature anchors: [PMC10181851](https://pmc.ncbi.nlm.nih.gov/articles/PMC10181851/), [Frontiers 2026](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2026.1781338/full).

#[cfg(target_os = "redox")]
mod desktop {
    use bos_ts_kernel::{
        ts_idle_tick_full, TsNodeState, TensionRing, MAX_NODES, PHI as KERNEL_PHI,
    };
    use orbclient::{Color, EventOption, Renderer, Window};

    /// φ baseline — cross-frequency / resonance context (PMC10181851; Frontiers 2026).
    const PHI: f32 = KERNEL_PHI;

    const STRIP_H: i32 = 40;
    const PANEL_H: i32 = 112;
    const NODE_BASE_R: i32 = 9;

    #[derive(Clone, Copy, PartialEq, Eq)]
    enum Realm {
        Spacetime,
        Quantum,
        Orphan,
    }

    fn realm(i: usize) -> Realm {
        let third = MAX_NODES / 3;
        if i < third {
            Realm::Spacetime
        } else if i < 2 * third {
            Realm::Quantum
        } else {
            Realm::Orphan
        }
    }

    fn realm_color(r: Realm, heat: u8) -> Color {
        match r {
            Realm::Spacetime => Color::rgb(heat / 2 + 40, heat / 3 + 80, 220),
            Realm::Quantum => Color::rgb(heat / 3 + 30, 200, 220 - heat / 4),
            Realm::Orphan => Color::rgb(220, 120 + heat / 4, 60 + heat / 6),
        }
    }

    fn label_char(r: Realm, i: usize) -> char {
        match r {
            Realm::Spacetime if i == 0 => 'R',
            Realm::Spacetime => 'S',
            Realm::Quantum => 'Q',
            Realm::Orphan => 'O',
        }
    }

    fn init_nodes() -> [TsNodeState; MAX_NODES] {
        let mut a = [TsNodeState::default(); MAX_NODES];
        for i in 0..MAX_NODES {
            let t = i as f32 * 0.07;
            a[i].activation = 0.25 + 0.04 * t.sin().abs();
            a[i].base_strength = match realm(i) {
                Realm::Spacetime => 0.52,
                Realm::Quantum => 0.48,
                Realm::Orphan => 0.38,
            };
            a[i].stability = 0.65 + 0.003 * (i as f32);
        }
        a[0].activation = 0.92;
        a[0].stability = 0.95;
        a
    }

    /// φ-spiral layout with user-tunable resonance (slider scales angular/radial spread).
    fn phi_layout(i: usize, cx: i32, cy: i32, phi_res: f32, frame: u64) -> (i32, i32) {
        let fi = i as f32;
        let wave = (frame as f32 * 0.02 + fi * 0.31).sin() * 6.0;
        let r = 28.0 + fi.sqrt() * 14.0 * phi_res + wave;
        let theta = fi * 0.28 * phi_res;
        let x = cx + (r * theta.cos()) as i32;
        let y = cy + (r * theta.sin()) as i32;
        (x, y)
    }

    fn draw_wave_background(w: &mut Window, x0: i32, y0: i32, ww: i32, hh: i32, frame: u64) {
        for row in (0..hh).step_by(3) {
            let t = (frame as i32 + row) as f32 * 0.04;
            let c = ((t.sin() * 0.5 + 0.5) * 40.0) as u8;
            w.rect(
                x0,
                y0 + row,
                ww as u32,
                3,
                Color::rgb(12 + c / 2, 14 + c / 3, 22 + c),
            );
        }
        // Animated “quantum” wave trace (decorative)
        let mut px = x0;
        let my = y0 + hh - 24;
        while px < x0 + ww {
            let ang = (px as f32) * 0.02 + (frame as f32) * 0.08;
            let py = my + (ang.sin() * 12.0) as i32;
            w.rect(px as i32, py, 3, 3, Color::rgb(100, 180, 220));
            px += 5;
        }
    }

    fn draw_top_tension_strip(w: &mut Window, wdt: i32, tension: f32, empty_peace: bool) {
        w.rect(0, 0, wdt as u32, STRIP_H as u32, Color::rgb(26, 30, 42));
        let bar_w = ((wdt as f32) - 24.0) * tension.clamp(0.0, 1.0);
        w.rect(12, 12, bar_w as u32, 16, Color::rgb(230, 80, 90));
        let mut tx = 12;
        let ty = 14;
        let status = if empty_peace { "EMPTY PEACE" } else { "ACTIVE   " };
        for ch in format!(
            "TensionRing (mirror)  t={:.3}  Break>0.85  [{}]  φ-resonance literature: PMC10181851 / Frontiers 2026",
            tension, status
        )
        .chars()
        {
            w.char(tx, ty, ch, Color::rgb(235, 235, 245));
            tx += 8;
            if tx > wdt - 24 {
                break;
            }
        }
    }

    fn draw_root_panel(
        w: &mut Window,
        y0: i32,
        wdt: i32,
        phi_res: f32,
        empty_peace: bool,
    ) {
        w.rect(0, y0, wdt as u32, PANEL_H as u32, Color::rgb(22, 26, 34));
        w.rect(0, y0, wdt as u32, 22, Color::rgb(36, 42, 56));
        let title = "Root Node Controls — [P] Empty Peace (global Relax)  [ / ] φ-resonance  [1][2] root ±";
        let mut tx = 8;
        let ty = y0 + 4;
        for ch in title.chars() {
            w.char(tx, ty, ch, Color::rgb(220, 225, 240));
            tx += 8;
        }
        let mut lx = 8;
        let ly = y0 + 32;
        for ch in format!(
            "φ slider: {:.4}  (kernel PHI baseline {:.4})  |  Empty Peace: {}",
            phi_res,
            PHI,
            if empty_peace { "ON " } else { "OFF" }
        )
        .chars()
        {
            w.char(lx, ly, ch, Color::rgb(190, 200, 220));
            lx += 8;
        }
        // Slider track
        let sw = wdt - 40;
        w.rect(20, y0 + 52, sw as u32, 8, Color::rgb(50, 55, 70));
        let knob = ((phi_res - 0.5) / 2.0).clamp(0.0, 1.0) * (sw as f32);
        w.rect(20 + knob as i32, y0 + 48, 12, 16, Color::rgb(240, 200, 120));
        let mut hx = 20;
        let hy = y0 + 72;
        for ch in "Graph: spacetime (S) · quantum (Q) · orphans (O) — animated φ waves".chars() {
            w.char(hx, hy, ch, Color::rgb(160, 170, 190));
            hx += 8;
        }
    }

    pub fn run() {
        let mut wdt: u32 = 1280;
        let mut hgt: u32 = 800;
        let mut window = Window::new(0, 0, wdt, hgt, "TS-OS — Thinking System Desktop")
            .expect("orbclient window");

        let mut nodes = init_nodes();
        let mut count = MAX_NODES;
        let mut ring = TensionRing::<256>::new();
        let mut empty_peace = false;
        let mut phi_resonance = PHI;
        let mut frame: u64 = 0;

        loop {
            let gw = wdt as i32;
            let graph_top = STRIP_H;
            let graph_bot = (hgt as i32) - PANEL_H;
            let graph_h = graph_bot - graph_top;

            let _t = ts_idle_tick_full(&mut nodes, &mut count, &mut ring, empty_peace);
            let tension = ring.last();

            draw_wave_background(&mut window, 0, graph_top, gw, graph_h, frame);
            draw_top_tension_strip(&mut window, gw, tension, empty_peace);

            let cx = gw / 2;
            let cy = graph_top + graph_h / 2 + 10;

            let mut pos: Vec<(i32, i32)> = Vec::with_capacity(count);
            for i in 0..count {
                let (x, y) = phi_layout(i, cx, cy, phi_resonance, frame);
                let pulse =
                    ((frame as f32) * 0.05 + i as f32 * phi_resonance * 0.1).sin() * 0.35;
                let nr = NODE_BASE_R + (pulse * 10.0) as i32;
                let rlm = realm(i);
                let heat = (tension * 200.0) as u8;
                let col = realm_color(rlm, heat);
                window.circle(x, y, nr, col);
                let ch = label_char(rlm, i);
                window.char(x - 3, y - 4, ch, Color::rgb(255, 255, 255));
                pos.push((x, y));
            }

            for i in 0..count {
                let j = (i + 1) % count;
                let (x1, y1) = pos[i];
                let (x2, y2) = pos[j];
                window.line(x1, y1, x2, y2, Color::rgb(80, 100, 140));
                if i != 0 {
                    let (xr, yr) = pos[0];
                    window.line(xr, yr, x1, y1, Color::rgb(70, 120, 160));
                }
            }

            draw_root_panel(&mut window, graph_bot, gw, phi_resonance, empty_peace);

            window.sync();

            for event in window.events() {
                match event.to_option() {
                    EventOption::Quit(_) => std::process::exit(0),
                    EventOption::Resize(e) => {
                        wdt = e.width as u32;
                        hgt = e.height as u32;
                    }
                    EventOption::Key(key) => {
                        if key.pressed {
                            match key.character {
                                'q' | 'Q' => std::process::exit(0),
                                'p' | 'P' => empty_peace = !empty_peace,
                                '[' => phi_resonance = (phi_resonance - 0.02).max(0.5),
                                ']' => phi_resonance = (phi_resonance + 0.02).min(2.5),
                                '1' => nodes[0].activation = (nodes[0].activation + 0.08).min(1.0),
                                '2' => nodes[0].activation = (nodes[0].activation - 0.08).max(0.0),
                                _ => {}
                            }
                        }
                    }
                    _ => {}
                }
            }

            frame = frame.wrapping_add(1);
            std::thread::sleep(std::time::Duration::from_millis(16));
        }
    }
}

#[cfg(target_os = "redox")]
fn main() {
    desktop::run();
}

#[cfg(not(target_os = "redox"))]
fn main() {
    eprintln!(
        "bos-ts-orbital: TS-OS live desktop builds on Redox (x86_64-unknown-redox).\n\
         Host check: rustup target add x86_64-unknown-redox && cargo check -p bos-ts-orbital --target x86_64-unknown-redox"
    );
}
