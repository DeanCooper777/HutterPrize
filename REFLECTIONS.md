# End-of-project reflections (18 Nov 2026)

This project is closed. It set out to win a Hutter Prize award by beating the record by the
required 1%. It reached a measured 1.025% over fx2-cmix-T (99,395,679 bytes against a threshold of
99,420,425), but the entry was never submitted: cmix-neif 2.0 appeared at 93,388,956 bytes, about
7% below the same record, before our final verification run was done. The later work, a fast
split evaluation and other speed modes for cmix-neif 2.0, is published at
<https://github.com/DeanCooper777/HutterPrize2>.

These notes record what we take from it. They were written by Claude (the AI that did most of the
implementation) and Dean Cooper together, at close-out.

## The short version

We lost on the choice of problem, not on execution. We spent the project squeezing 1% out of the
existing leader while someone else changed the model and took 7%. What survived being passed was
not the compression gain but the evaluation tooling.

## What went wrong

- **We optimised the wrong thing.** Retraining the transformer to complement cmix, retuning the
  mixer and building our own executable packer were sound and did add up to 1.025%. But cmix-neif
  got its gain from a different transformer (16 layers, one step per byte, a new training recipe).
  A 1% threshold invites incremental work, and the real risk in a contest like this is that the
  frontier jumps while you polish.
- **We measured too slowly for too long.** For most of the project each real answer cost a
  34 to 49 hour run, so we could afford very few of them. The fast split evaluation is the tool we
  needed in the first week; with it we could have screened many more ideas, including bolder ones.
- **Proxies misled us more than once.** A stand-in for cmix's mixer favoured weights trained for
  it (72 KB better on the proxy, 0.04% for real). A simulation of parallel decoding predicted 1.8x
  where the measured ceiling was about 1.3x. A guess that VNNI instructions were the kernel win was
  wrong; packing the weights was. Each time, only the real measurement settled it.
- **Some of the AI's numbers were wrong.** A pilot was quoted at a quarter of its real cost, and
  noise was labelled as evidence that a training loss helped. An independent reviewer agent (below)
  caught these and others before they cost money.
- **Money went to training runs with weak evidence behind them.** Part of the cloud spend bought
  runs whose premise had not been tested cheaply first. The fine-tune track on cmix-neif is the
  case that went right: it was stopped before renting anything, because nothing showed the
  proposed loss actually helped.

## What went right

- **The 1% was real, though never proven end to end.** The sizes are measured, but the final
  official build was never decompressed and verified, so it was a credible claim and not a finished
  entry. Only the first version (10 Nov) was verified end to end.
- **The speed work is useful to other people.** A four-day compress-and-check cycle on cmix-neif
  2.0 now takes under eight hours on one rented 32-thread machine, with identical output, for
  roughly 10 to 25 US dollars of compute.
- **The negative results are published.** Packed kernels gain 18 to 24% on a Lunar Lake laptop but
  2 to 9% on Zen 4; a speculative threaded decoder tops out near 1.3x; the cmix-neif packer beat
  ours. Others can skip those.
- **Pivoting when cmix-neif appeared was the right decision.** Defending a 1% entry against a 7%
  one would have wasted more.

## What we would do differently

1. Build the fast evaluation loop before any compression idea.
2. Put an early, cheap test on the biggest lever (model architecture and training) before
   investing in small ones.
3. Require a cheap, isolated measurement before any spend, and have it reviewed.
4. Read the contest's discussion group weekly. An entry that changes the baseline changes the plan.

A caveat: this is hindsight. Nothing here shows a bolder plan would have beaten cmix-neif, whose
author had a head start on training infrastructure. What can be said is that our plan could at
best have won by a small margin for a short time, and that was knowable early.

## The reviewer agent

Partway through, Dean asked for an independent reviewer: a second AI agent that receives each
recommendation verbatim, with the raw evidence and the cost, and answers four questions (is it
reasonable, what is wrong, what misses the larger picture, what cheap improvement is there) before
anything is acted on. It caught an under-quoted cost, noise presented as evidence, and a cloud
test plan in which three of four configurations would not have fitted in memory. It worked because
it was independent of the recommender's reasoning, because it ran before the spend and not after,
and because its brief was narrow. Its definition is in `.claude/agents/recommendation-reviewer.md`.
We would use one from the first day of any similar project.

## Speed of the field

Matt Mahoney, who created the benchmark, wrote on the contest's discussion list in mid-November
2026 that the record had improved by about 2% a year from 2006 to early 2026, and then by as much
again in the four months since July ("20 years of progress in 4 months"), which he attributed to
AI-generated code and documentation.

Dean's reflection on that: things are accelerating, and an idea can no longer be put on a shelf;
if you do, someone else will have the same idea and use AI to make it happen. He had thought of
trying the Hutter Prize months earlier but had not thought of using AI to do the work until
shortly before this project began, and that was too late. The lessons he draws are to think
ideas through and run with them quickly, and to find out what others are already doing.

Two refinements from the close-out discussion:

- When AI collapses the cost of implementing an idea, the scarce things become **evaluation
  speed** (whoever measures fastest gets the most attempts), **knowing the field**, and **choosing
  the lever**. Cheap implementation is also a trap: we could afford to polish, so we polished.
- "Run with it quickly" should mean moving fast to the first cheap measurement and then deciding.
  Our expensive mistakes came from moving before a cheap test, not from moving too slowly. And
  because leads now last a shorter time, the question to ask of an idea is less "can I get there
  first" than "what will still be worth having after someone passes me".

This project took about twelve days. Being a few months earlier would have mattered more than
being better.
