#define POT_PIN A0

String matlab_input = "";
bool  matlab_input_done = false;
String data = "";

long input = 0;
long output = 0; 

void setup() {
	Serial.begin(2000000);						//set serial baudrate to 9600
  	matlab_input.reserve(200);				//reserve space for the matlab input string
}

void loop() {
	//check if matlab wants data
	if(matlab_input_done == true){ 
		
		if(matlab_input == "send_data\n")
			Serial.println(data);
		
		matlab_input = "";					//reset the input string
		
		matlab_input_done = false;			//reset the input flag
	}

	long input = analogRead(POT_PIN);
  
  	long output = input * 255/1023;

  	data = String(output);
  	//data += (char) '\n';
}


void serialEvent(){
	while(Serial.available()){
		char tmp = (char) Serial.read();	//get the next character

		matlab_input += tmp;

		if(tmp == '\n')
			matlab_input_done = true;		//set the input flag
	}
}
