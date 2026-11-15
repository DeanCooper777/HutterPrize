// misc.h: cuts enwik9 into three parts by line number, and back.
//   intro: the XML header in front of the first <page>;
//   main:  the pages that are reordered and phda9-transformed;
//   coda:  the last lines of the file (enwik9 ends in the middle of a page), which are
//          left alone.
// The stream handed to cmix is main (transformed) + intro + coda, in that order.
//
// Place in the pipeline: the very first step of compression (split4Comp) and one of the
// last steps of decompression (split4Decomp). Called from main() in runner.cpp.
//
// Unchanged from the previous winning entry.

// Line numbers (0-based count of '\n' seen so far) at which enwik9 is cut.
#define COMP_INTRO_END_LINE 29
#define COMP_MAIN_END_LINE  13146932
#define COMP_CODA_END_LINE  13147025

// Not used: split4Decomp below has its own literal line numbers.
#define DECOMP_MAIN_END_LINE  13146905
#define DECOMP_INTRO_END_LINE 13146934 
#define DECOMP_CODA_END_LINE  13147027

// enwik9 -> .intro, .main, .coda
void split4Comp(char const *enwik9_filename) {
  FILE* ifile = fopen(enwik9_filename, "rb");
  FILE* ofile1 = fopen(".intro", "wb");
  FILE* ofile2 = fopen(".main", "wb");
  FILE* ofile3 = fopen(".coda", "wb");  
  int line_count = 0;
  
  do {
    int c=getc(ifile);
    if (c==EOF) break;
    if (line_count < COMP_INTRO_END_LINE) {
      putc(c,ofile1);
    } else if (line_count < COMP_MAIN_END_LINE) {
      putc(c,ofile2);
    } else if (line_count < COMP_CODA_END_LINE) {
      putc(c,ofile3);
    } else {
      putc(c,ofile3);
    }
    if (c==10)
    line_count++;
  }
  while (!feof(ifile));
  fclose(ifile);
  fclose(ofile1);
  fclose(ofile2);
  fclose(ofile3);
}

// .input_decomp (main + intro + coda, as decoded) -> .main_decomp, .intro_decomp,
// .coda_decomp. The main part comes first here, and it is still in its phda9-transformed
// form, so its line count differs from the one in split4Comp.
void split4Decomp() {
  FILE* ifile = fopen(".input_decomp", "rb");
  FILE* ofile1 = fopen(".intro_decomp", "wb");
  FILE* ofile2 = fopen(".main_decomp", "wb");
  FILE* ofile3 = fopen(".coda_decomp", "wb");  
  int line_count = 0;
  
  do {
      int c=getc(ifile);
      if (c==EOF) break;
    if (line_count < 13146906) {
      putc(c,ofile2);
    } else if (line_count < 13146935) {
        putc(c,ofile1);
    } else if (line_count < 13147027) {
        putc(c,ofile3);
    } else {
        putc(c,ofile3);
    }
    if (c==10)
    line_count++;
  }
  while (!feof(ifile));
  fclose(ifile);
  fclose(ofile1);
  fclose(ofile2);
  fclose(ofile3);
  
}
