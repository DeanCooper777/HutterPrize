#!/bin/bash
# How much does the LSTM help on the two embedded tables? One run at a time (each maps a 14 GB PPMD file).
P=/mnt/c/Dean/Projects/HutterPrize/cmix-T-dwc; T=/root/lstmtest; rm -rf $T; mkdir -p $T; cd $T; cp /root/build/cmix-T-dwc/run/cmix_orig cmix
r() { s=$(date +%s); ./cmix -c $1 $2 $3 > $2.log 2>&1; echo "$2 rc $? size $(stat -c %s $2) $(( $(date +%s) - s )) s"; rm -f ppm.temp *.temp; }
r $P/dictionary/english.dic dict.lstm
r $P/dictionary/english.dic dict.nolstm --no-transformer
r $P/src/readalike_prepr/data/new_article_order order.lstm
r $P/src/readalike_prepr/data/new_article_order order.nolstm --no-transformer
