// context.h: base class of the cmix-style context objects.
//
// A context object turns the recent history into one number (context_, in [0, size_)) that a
// model or a mixer uses to select its statistics. ContextManager (src/context-manager.*) owns
// the objects, calls Update() on each of them once per coded byte, and hands out references to
// context_; the models keep that reference, so they always see the current value.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
// The contexts are the selectors of the context-model stage (Direct, Indirect, Match).
//
// Update() and IsEqual() are not virtual: ContextManager stores each derived type in its own
// container and calls the derived function directly. IsEqual() lets the manager reuse an
// existing context when the same one is requested twice.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef CONTEXT_H
#define CONTEXT_H

// context_: the current value. size_: the number of distinct values (the table size a
// directly indexed model needs).
class Context {
 public:
  virtual ~Context() {}
  bool IsEqual(Context* c) { return false; }
  const unsigned long long& GetContext() const { return context_; }
  unsigned long long Size() const { return size_; }

 protected:
  void Update() {}
  unsigned long long context_, size_;
};

#endif

