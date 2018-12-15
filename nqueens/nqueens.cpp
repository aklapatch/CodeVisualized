#include <iostream>
#include <stack>
#include <cstdlib>
#include <ctype.h>
#include <utility>

// simplify naming
typedef std::pair<int,int> queen;

// checks for conflict between queens
bool isConflict(std::stack<queen> t_q_stack, unsigned int board_size){
	
	// set aside queen to compare
	queen compare = t_q_stack.top();
	t_q_stack.pop();

	while( !t_q_stack.empty()){
		
		// checks if the queen is off the board or if it conflicts with queen vertically`
		if( compare.second == t_q_stack.top().second){
			return true;
		}

		// compare y intercepts for diagonal lines that the queens make
		int b = compare.first - compare.second;
		int b2 = t_q_stack.top().first - t_q_stack.top().second;
		int b3 = compare.first + (compare.second - board_size);
		int b4 = t_q_stack.top().first + (t_q_stack.top().second - board_size);

		// if they are the same, queens conflict
		if ( b == b2 || b3 == b4 ){
			return true;
		}
		
		//set to check next member
		t_q_stack.pop();
	}
	return false;
}

bool shift(queen& t_in, unsigned int board_size){
	
	// return false if queen is on edge of the board
	if(t_in.second >= board_size){
		
		return false;
		
	} else {
		// move the queen to the right to the next column
		++t_in.second;
	}
	// move succeeded
	return true;	
}

int main(int argc, char ** argv) {
	
	// print usage guidelines and exit if there is not a number
	if(argc < 2 || !isdigit(argv[1][0]) ){
		std::cerr << "Usage: " << argv[0] << " NumberOfRows\n";
		return 0;
	}
	// set sized based on argument
	int board_size = std::atoi(argv[1]);
	
	// exit if the input is too small
	if(board_size < 4 && board_size > 1){
		std::cerr << "Sizes 2 and 3 have no solution. Exiting\n";
		return 0;
	}
	
	// make first stack
	std::stack<queen> queen_stack;
	
	while(queen_stack.size() < board_size){

		// make new queen at starting position next column up
		queen_stack.push(std::pair<int,int>(queen_stack.size() + 1, 1));

		// while there is conflict
		while(isConflict(queen_stack, board_size)){

			// pop if member cannot be shifted
			while( !shift(queen_stack.top(),board_size)){			
				queen_stack.pop();
			} 
		}		
	}
	
	// output solutions
	std::cout << "Final positions:\n";
	for(int i = 0; i < board_size; ++i){
		for(int j = 1; j <= board_size; ++j){
			
			// output a 1 to indicate where the queen was
			if(queen_stack.top().second == j){
				std::cout <<  " 1 ";
			}
			else {
				std::cout << " 0 ";
			}
		}
		std::cout << "\n";
		queen_stack.pop();
	}

	return 0;
}
