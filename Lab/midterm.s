display welcome menu with options
1 for gross pay calc
2 for subscription packages
3 for fibonacci sequence
take input from user
//need to loop menu to repeat programs????
if (input != 1 - 3)
	then exit program

gross pay calculator ()					// switch case instead???
	display: hours worked?, rate of pay?
	input hours, pay rate
	if ( hours are between 20 and 40)
		then pay rate * 2
	if ( hours are greater than 40)
		then pay rate * 3
	gross pay = hours worked * pay rate
	display gross pay
	end program

subscription package ()					// switch case instead???
	display package options and ask user to 
	choose a, b, or c respectively:
	"30 a month, 11 hours, $3 for additional hrs up to 
	22 hrs then $6 after"
	"35 a month, 22 hours, $2 for additional hrs up to 
	44 hrs then $4 after"
	"40 a month, 33 hours, $1 for additional hrs up to 
	66 hrs then $2 after"
	input user choice
	ask for hourly usage
	input user int
	int monthly charge
	if ( user choice ==  a )
		if ( user int > 11 && user int <= 22)
			user int = (user int - 11) * 3
		else if ( user int > 22)
			user int = (user int -22) *6 + 33   // +33 for the previous hrs
		int monthly charge = user int + 30 // total monthly charge
	else if ( user choice ==  b )
		if ( user int > 22 && user int <= 44)
			user int = (user int - 22) * 2
		else if ( user int > 44)
			user int = (user int -44) *4 + 44   // +44 for the previous hrs
		int monthly charge = user int + 35 
	else if ( user choice ==  c )
		if ( user int > 33 && user int <= 66)
			user int= user int - 33
		else if ( user int > 66)
			user int = (user int -66) *2 + 33   // +33 for the previous hrs
		int monthly charge = user int + 40 
	display monthly charge
	end program

fibonacci sequence ()					// switch case instead???
	do loop					// clear out register through each loop
		ask user for fibInt in the fibonacci sequence	
		while ( int != fibonacci number )		
	fibInt = fibInt - 1 + fibInt - 2
	display fibInt
	end program
	
	
		
