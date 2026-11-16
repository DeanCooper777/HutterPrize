# Model-size sweep: results log

Started 2026-11-15 on one RTX PRO 6000 ($2.69/h). Data: our own training stream (fx2 lineage,
593,343,776 tokens), slices of whole articles:

| slice | tokens | from | what | cmix alone (bits/byte) |
|---|---:|---:|---|---:|
| A16 | 15,994,480 | 212,006,297 | prose articles (hard) | 2.247 |
| B16 | 16,000,650 | 524,000,796 | census pages (easy) | — |
| A64 | 64,014,269 | 196,000,818 | prose, contains A16 | — |

Each run: from scratch, bf16, no quantization, cmix mixture loss (CE weight 0.1), 150 epochs on
the 16 MB slices (75 on A64), batch 131,072 tokens, LR 5e-4. Scored in file order.
`coded_B` = cost through the stand-in mixer; `weights2x` = 2 x params x 3.5 bits (assumed);
`net_B` = their sum; `vs_cmix` = net against cmix without a transformer. Regenerate the table with
`sw_fetch.sh HOST PORT`; raw JSON in `runs/sweep/`.

## Results (all 24 runs finished 2026-11-16 03:23 CST; machine deleted)

B16: cmix alone 0.4270 bits/byte (853,667 B).

| run | slice | step | params | tf bpc | mix bpc | coded B | weights x2 | net B | vs cmix |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| b16_s0 | B16 | byte | 38,615 | 0.5552 | 0.4070 | 813,640 | 33,788 | 847,428 | −6,239 |
| b16_s1 | B16 | byte | 114,087 | 0.4923 | 0.3871 | 773,915 | 99,826 | 873,742 | +20,074 |
| b16_s2 | B16 | byte | 395,539 | 0.4271 | 0.3417 | 683,010 | 346,097 | 1,029,107 | +175,439 |
| b16_s3 | B16 | byte | 1,238,892 | 0.3256 | 0.1929 | 385,624 | 1,084,030 | 1,469,655 | +615,987 |
| b16_s4 | B16 | byte | 2,791,142 | 0.1340 | 0.0555 | 111,028 | 2,442,249 | 2,553,277 | +1,699,610 |
| pb16_s1 | B16 | token | 248,551 | 0.4823 | 0.3818 | 763,251 | 217,482 | 980,733 | +127,066 |
| pb16_s2 | B16 | token | 609,523 | 0.4137 | 0.3321 | 663,938 | 533,333 | 1,197,271 | +343,603 |
| pb16_s3 | B16 | token | 1,540,588 | 0.3072 | 0.1874 | 374,568 | 1,348,014 | 1,722,583 | +868,915 |
| pb16_s4 | B16 | token | 3,292,838 | 0.1182 | 0.0442 | 88,393 | 2,881,233 | 2,969,626 | +2,115,959 |

A16:

| run | slice | step | params | tf bpc | mix bpc | coded B | weights x2 | net B | vs cmix |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| a16_s0 | A16 | byte | 38,615 | 2.7094 | 2.1867 | 4,370,846 | 33,788 | 4,404,635 | −86,244 |
| a16_s1 | A16 | byte | 114,087 | 2.5752 | 2.1483 | 4,293,969 | 99,826 | 4,393,795 | −97,083 |
| a16_s2 | A16 | byte | 395,539 | 2.3711 | 2.0567 | 4,110,877 | 346,097 | 4,456,973 | −33,905 |
| a16_s3 | A16 | byte | 1,238,892 | 2.1852 | 1.8811 | 3,759,871 | 1,084,030 | 4,843,901 | +353,023 |
| a16_s4 | A16 | byte | 2,791,142 | 1.8722 | 1.5664 | 3,131,009 | 2,442,249 | 5,573,258 | +1,082,380 |
| pa16_s1 | A16 | token | 248,551 | 2.5494 | 2.1374 | 4,272,277 | 217,482 | 4,489,759 | −1,119 |
| pa16_s2 | A16 | token | 609,523 | 2.4224 | 2.0621 | 4,121,792 | 533,333 | 4,655,124 | +164,246 |
| pa16_s3 | A16 | token | 1,540,588 | 2.2766 | 1.8899 | 3,777,473 | 1,348,014 | 5,125,487 | +634,609 |
| pa16_s35 | A16 | token | 2,304,604 | 2.1498 | 1.7467 | 3,491,334 | 2,016,528 | 5,507,863 | +1,016,984 |
| pa16_s4 | A16 | token | 3,292,838 | 1.9816 | 1.5581 | 3,114,322 | 2,881,233 | 5,995,555 | +1,504,677 |

Token-step runs: trunk steps 9,508,535 for 15,990,385 bytes on A16 (−40.5%). Their parameter
count includes the per-position byte tables and the in-token head (134 k extra at d_model 64).
On B16 the token-step trunk takes 10,075,975 steps for 15,992,856 bytes (−37.0%).

A64 (75 epochs): cmix alone 2.1519 bits/byte (17,215,055 B).

| run | slice | step | params | tf bpc | mix bpc | coded B | weights x2 | net B | vs cmix |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| a64_s2 | A64 | byte | 395,539 | 2.1739 | 1.9624 | 15,699,017 | 346,097 | 16,045,114 | −1,169,941 |
| a64_s3 | A64 | byte | 1,238,892 | 1.9940 | 1.8594 | 14,874,732 | 1,084,030 | 15,958,762 | −1,256,292 |
| a64_s4 | A64 | byte | 2,791,142 | 1.8294 | 1.7473 | 13,977,768 | 2,442,249 | 16,420,018 | −795,037 |
| pa64_s3 | A64 | token | 1,540,588 | 2.1355 | 1.8881 | 15,104,297 | 1,348,014 | 16,452,312 | −762,743 |
| a64_s5 | A64 | byte | 5,897,145 | 1.6352 | 1.5658 | 12,525,895 | 5,160,002 | 17,685,897 | +470,842 |

## Fit (`sw_fit.py`), byte steps on prose

Two-term reading: saved(P, data) = a(P) x C + m(P), with C the cost of the data under cmix alone.
a(P) is the share that scales with the data; m(P) is memorised content that does not.

| params | saved on 16 MB | saved on 64 MB | a | m |
|---:|---:|---:|---:|---:|
| 395,539 | 380,001 | 1,516,037 | 0.0893 | about 0 |
| 1,238,892 | 731,008 | 2,340,322 | 0.1265 | 163,015 B (1.05 bits/param) |
| 2,791,142 | 1,359,870 | 3,237,286 | 0.1475 | 697,253 B (2.00 bits/param) |

a rises 0.0326 per e-fold of parameters between the first two sizes and 0.0259 between the last
two. Size where one more parameter stops paying (3.5 bits/param, weights counted twice):

| data | optimum, a only | optimum, with the memorisation term |
|---|---:|---:|
| 16 MB | 0.13-0.17 M | 0.22 M |
| 64 MB | 0.51-0.64 M | 0.84-0.85 M |
| full stream (C assumed 126 MB) | 3.7-4.7 M | 6.2 M |

Limits: no quantization; 3.5 bits/param assumed; 75 epochs on 64 MB against 150 on 16 MB, which
is confounded with data size in a and m; C for the full stream is an estimate from the region
profile, not a sum; one prose region only; our stream, not cmix-neif's; time limit not modelled.
