#include "../src/stockfishcli.h"
#include <uci.h>
#include <bitboard.h>
#include <evaluate.h>
#include <position.h>
#include <search.h>
#include <thread.h>
#include <tt.h>
#include <uci.h>
#include <syzygy/tbprobe.h>
#include <movegen.h>
#include <timeman.h>

int main(int argc, char **argv)
{
  printf("---------->\n");
  std::streambuf* originOut = std::cout.rdbuf();

  std::ostringstream myout;
  std::cout.rdbuf(myout.rdbuf());

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

  stockfishcli::commandInit();
  stockfishcli::command("position startpos moves e2e4");
  stockfishcli::command("go depth 15");

  Threads.main()->join();

  std::cout.rdbuf(originOut);
  std::cout << "-------------------\n";
  std::cout << myout.str();
}
