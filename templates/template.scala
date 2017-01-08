#! /usr/bin/env scala
object A747B {
  case class Answer(n: Int){
    def next: Answer = Answer(n + 1)
  }
  def main(args: Array[String]): Unit = {
    val word = scala.io.StdIn.readLine;
    print(Answer(3).next)
  }
}
