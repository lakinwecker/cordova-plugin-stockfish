#include <jni.h>
#include <string>
#include <stockfishcli.h>

extern "C" {
  JNIEXPORT void JNICALL Java_org_lichess_stockfish_StockfishLib_init(JNIEnv *env, jclass clazz);
  JNIEXPORT void JNICALL Java_org_lichess_stockfish_StockfishLib_exit(JNIEnv *env, jclass clazz);
  JNIEXPORT jstring JNICALL Java_org_lichess_stockfish_StockfishLib_cmd(JNIEnv *env, jclass clazz, jstring cmd);
};

JNIEXPORT void JNICALL Java_org_lichess_stockfish_StockfishLib_init(JNIEnv *env, jclass clazz) {
  UCI::init(Options);
  PSQT::init();
  Bitboards::init();
  Position::init();
  Bitbases::init();
  Search::init();
  Eval::init();
  Pawns::init();
  Threads.init();
  Tablebases::init(Options["SyzygyPath"]);
  TT.resize(Options["Hash"]);
}

JNIEXPORT void JNICALL Java_org_lichess_stockfish_StockfishLib_exit(JNIEnv *env, jclass clazz) {
}

JNIEXPORT jstring JNICALL Java_org_lichess_stockfish_StockfishLib_cmd(JNIEnv *env, jclass clazz, jstring cmd) {
  return env->NewStringUTF("ping");
}
