Wave 043 — fix-three-bugs-mode-manager-router-throttle

**Propagate** 
User request activates: mode_manager timeout semantics, router handling of request_user_mode, ThrottlePolicy typing; workspace TS wave save at 043.

**Relax / Tension detected** 
Prior code passed full timeout each wait (constraint violated: bounded wall time). Router ignored False. ThrottlePolicy int vs float comparison tension — low.

**Break** (if applicable) 
Fixed-duration wait loop replaced with monotonic deadline and remaining.

**Evolve** 
mode_manager uses end_time and remaining per wait; router returns busy QueryResponse on timeout; ThrottlePolicy uses float default.

**Final stable configuration / Answer** 
Implemented: (1) `request_user_mode` with `time.monotonic()`, `remaining`, early exit when `remaining <= 0`; (2) `process_text` checks `request_user_mode()`, logs warning, returns `QueryResponse` with answer "System busy, please try again"; (3) `ThrottlePolicy.min_interval_seconds: float = 60.0`.
