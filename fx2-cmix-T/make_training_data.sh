# make_training_data.sh -- produces the inputs for training the transformer.
#
# The transformer byte model is trained offline (pysrc/) on exactly the token
# stream that cmix codes: enwik9 after article reordering, preprocessing and
# dictionary coding. It also takes PPMD's prediction for each byte as an extra
# input (the "prior"). This script downloads enwik9, builds the compressor and
# runs it in a special mode that saves, into data/:
#   ppmd-bytes.uint8           the preprocessed byte stream
#   ppmd-probs.float16         PPMD's probability distribution at every byte
#   article-boundaries.int32   where each article starts in that stream
# --ppmd-only skips the other models, so no usable archive is produced. The
# output is large (SUBMISSION.md: about 300 GB).
#
# These options are development options: build WITHOUT OFFICIAL=1 for this
# script (the official build removes them).
#
# Unchanged from the previous winning entry. [this entry] adds a further
# training input, cmix's own bit predictions, generated separately (see
# SUBMISSION.md, "Retrain the weights").
set -euo pipefail

make data/enwik9
./build_and_construct_comp.sh

pushd run
./cmix -e ../data/enwik9 enwik9.comp --ppmd-only --save-ppmd-bytes ../data/ppmd-bytes.uint8 --save-ppmd-probs ../data/ppmd-probs.float16 --save-article-boundaries ../data/article-boundaries.int32
popd
