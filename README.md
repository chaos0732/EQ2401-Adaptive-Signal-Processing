# EQ2401 Adaptive Signal Processing

Both project assignments from KTH course EQ2401 Adaptive Signal Processing, 2025.
Each project denoises a piece of speech audio, but from two different angles: project 1
assumes the noise statistics are known and derives the optimal filter from them, project 2
drops that assumption and lets the filter adapt on its own.

| | Topic | Filters |
|---|---|---|
| [**project1/**](project1/) | Wiener filtering with known noise statistics | FIR (normal equations), non-causal, causal (spectral factorization) |
| [**project2/**](project2/) | Adaptive filtering, no reference signal available | High-pass, LMS, NLMS, RLS in an Adaptive Line Enhancer |

Each folder has its own README with the reasoning, the result figures and a file-by-file
description, plus the task PDF, the audio data and the slides used to present it.

Everything runs in MATLAB — open a project folder and run `Project.m` (project 1) or
`main.m` (project 2).
