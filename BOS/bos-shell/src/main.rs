//! BOS — Bootable TS-OS shell (userspace).
//!
//! **TS** = **Thinking System / Thinking Wave** (Ben Michalek / BoggersTheFish).
//! This is **not** the TypeScript language. For TypeScript docs only: <https://www.typescriptlang.org/docs/>
//!
//! Runtime loop (kernel goal): Propagate → Relax → tension → Break/Evolve — see `bos-kernel`.
//! Portal: <https://www.boggersthefish.com/> · org: <https://github.com/BoggersTheFish>

#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use bos_kernel::{ts_idle_tick, TsNodeState, PHI};

fn main() -> eframe::Result {
    let options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default()
            .with_inner_size([1024.0, 720.0])
            .with_title("BOS — TS-OS Shell (Thinking System)"),
        ..Default::default()
    };
    eframe::run_native(
        "BOS",
        options,
        Box::new(|_cc| Ok(Box::new(BosApp::default()))),
    )
}

struct BosApp {
    /// Live tension meter (stub — wired to kernel tick).
    tension: f32,
    /// Demo nodes for `bos_kernel::ts_idle_tick`.
    demo_nodes: Vec<TsNodeState>,
    /// φ-derived visual scale (golden ratio).
    phi_scale: f32,
    /// “Empty peace” mode — bias Relax toward base_strength globally.
    empty_peace_boot: bool,
    tick: u64,
}

impl BosApp {
    fn new() -> Self {
        let mut demo_nodes = vec![
            TsNodeState {
                activation: 0.72,
                base_strength: 0.5,
                stability: 0.85,
            },
            TsNodeState {
                activation: 0.35,
                base_strength: 0.5,
                stability: 0.6,
            },
        ];
        let t = ts_idle_tick(&mut demo_nodes, 0.55);
        Self {
            tension: t as f32,
            demo_nodes,
            phi_scale: PHI as f32,
            empty_peace_boot: false,
            tick: 0,
        }
    }
}

impl eframe::App for BosApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        ctx.request_repaint_after(std::time::Duration::from_millis(16));

        egui::TopBottomPanel::top("ts_menu").show(ctx, |ui| {
            ui.horizontal(|ui| {
                ui.label(egui::RichText::new("BOS — TS-OS").strong());
                ui.separator();
                ui.hyperlink_to(
                    "boggersthefish.com",
                    "https://www.boggersthefish.com/",
                );
                ui.hyperlink_to(
                    "BoggersTheAI",
                    "https://github.com/BoggersTheFish/BoggersTheAI",
                );
                ui.hyperlink_to(
                    "GOAT-TS",
                    "https://github.com/BoggersTheFish/GOAT-TS",
                );
            });
        });

        egui::SidePanel::left("tension_panel")
            .resizable(true)
            .default_width(220.0)
            .show(ctx, |ui| {
                ui.heading("Tension (stub)");
                ui.add(
                    egui::ProgressBar::new(self.tension)
                        .show_percentage()
                        .animate(true),
                );
                ui.label(format!("φ scale: {:.4}", self.phi_scale));
                ui.separator();
                ui.checkbox(&mut self.empty_peace_boot, "Empty peace boot (global Relax bias)");
                if self.empty_peace_boot {
                    ui.label(egui::RichText::new("Forcing low-tension presentation layer (demo).").small());
                }
            });

        egui::CentralPanel::default().show(ctx, |ui| {
            ui.heading("TS-OS Portal — live graph (skeleton)");
            ui.label(
                "Nodes = future inodes/processes; edges = constraints. Cytoscape-style viz next wave.",
            );
            ui.separator();

            for (i, n) in self.demo_nodes.iter().enumerate() {
                ui.group(|ui| {
                    ui.label(format!("Node {} — activation {:.3}", i, n.activation));
                    ui.label(format!("stability {:.3} | base {:.3}", n.stability, n.base_strength));
                });
            }

            if ui.button("Run one TS idle tick").clicked() {
                let neighbor = 0.5 + 0.1 * (self.tick as f64 * 0.01).sin();
                let t = ts_idle_tick(&mut self.demo_nodes, neighbor);
                self.tension = t as f32;
                self.tick += 1;
            }
        });

        egui::TopBottomPanel::bottom("status").show(ctx, |ui| {
            ui.label(format!(
                "Tick {} | bos-kernel PHI = {:.6} | Redox base: github.com/redox-os/redox",
                self.tick,
                PHI
            ));
        });
    }
}

impl Default for BosApp {
    fn default() -> Self {
        Self::new()
    }
}
