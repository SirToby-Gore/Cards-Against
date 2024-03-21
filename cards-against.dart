// ignore_for_file: unused_import
import "dart:io";
import "dart:math";

List? open(String path){
  var file = File(path);
  List<String> to_return = file.readAsLinesSync();
  return to_return;
}

class Cards{
  var deck;
  Cards(String path){
    this.deck = open(r"C:\Users\User\OneDrive\Progames\Dart\Cards\"+path);
    this.deck.shuffle();
  }
  List draw(int amount){
    var cards = [];
    if (this.deck.length > amount){
      for (var i = 0; i < amount; i++) {
        int to_remove = 0;
        cards.add(this.deck[to_remove]);
        this.deck.removeAt(to_remove);
      }
    }
    return cards;
  }
  int length(){
    return this.deck.length;
  }
}

class Player{
  var name; var points = 0; var hand = []; int index = 0;
  Player(String? name, List cards, int index){
    this.name = name;
    this.hand = cards;
    this.index = index;
  }
  void play(String card){
    if (this.hand.contains(card)){
      this.hand.remove(card);
    }
  }
}

int get_input_number(int uppper, int lower){
  String? inp;
  while (true) {
    print("choose a number between ($lower-$uppper): ");
    inp = stdin.readLineSync();
    if (inp != null){
      try {
        int new_num = int.parse(inp)-1;
        if (new_num >= lower-1 && new_num < uppper){
          return new_num;
        } else if (new_num >= uppper){
          print("too big!");
        } else {
          print("too small");
        }
      } catch (e) {
        print("Input a number");
      }
    }
  }
}

int incrament(num, max){
  if (num < max-1){
    return num+1;
  } else{
    return 0;
  }
}

int count(String str, String phr){
  int c = 0;
  for (var i = 0; i < str.length-phr.length; i++){
    List look = [];
    for (var j = 0; j < phr.length; j++) {
      look.add(str[i+j]);
    }
    if (look.join() == phr){
      c++;
    }
  }
  return c;
}

void main() {
  var White_Cards = Cards("White_Cards.txt");
  var Black_Cards = Cards("Black_Cards.txt");

  print("number of player: ");
  int number_of_players = get_input_number(20, 3); 
  List players = [];

  for (var i = 1; i < number_of_players+2; i++) {    
    print("what is name player$i?: ");
    var name = stdin.readLineSync();
    if(name == "") {
      name = "player$i";
    }
    var new_player = Player(name, White_Cards.draw(5), i-1);
    players.add(new_player);
  }

  int card_reader = 0;
  for (var question_card in Black_Cards.deck) {
    List submitted = [];
    for (var player in players) {
      print(question_card.split("{}").join("_____"));
      print(player.name);
      int score = player.points;
      print("score $score");
      List<String> chosen_cards = [];
      for (var i = 0; i < count(question_card, "{}"); i++) {
        int x = count(question_card, "{}");
        int y = i+1;
        print("$y/$x");
        if (player.index != card_reader) {
          int counter = 1;
          for (var card in player.hand) {
            print("$counter : $card");
            counter ++;
          }
          int chosen_card_index = get_input_number(player.hand.length, 1);
          chosen_cards.add(player.hand[chosen_card_index]);
          player.hand.removeAt(chosen_card_index);
          submitted.add([chosen_cards, player.index]);
        }
      }
      while (player.hand.length < 5){
        player.hand.add(White_Cards.draw(1)[0]);
      }
    }
    int counter = 1;
    for (var ans in submitted) {
      String ans2 = ans[0].join(", ");
      print("$counter : $ans2");
      counter++;
    }
    int winner_index = get_input_number(number_of_players, 1);
    players[winner_index].points++;
  }
}