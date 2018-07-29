#include <LiquidCrystal.h>
#include <DHT.h>
#include <ClickEncoder.h>
#include <TimerOne.h>

#define DHTPIN 8     
#define DHTTYPE DHT22

#define MAX_TEMP 80
#define MIN_TEMP 24

#define BASE_PWM 30

#define HEATER_PIN 11

DHT dht(DHTPIN, DHTTYPE);

ClickEncoder *encoder;
int16_t last, target_temp;
bool is_on = false;

int16_t counter = 0;
bool readDHT = true;

void timerIsr() {
    counter = counter + 1;
  // ~ 3 seconds
  if(counter == 3000)
  {
    readDHT = true;
    counter = 0;
  }
  encoder->service();
}
 
LiquidCrystal lcd(7, 6, 5, 4, 3, 2);

float humidity;
float temprature;
 
void setup()
{

Serial.begin(9600);

dht.begin();
lcd.begin(16, 2);

encoder = new ClickEncoder(A1, A0, A2);
encoder->setAccelerationEnabled(true);
//~ 1 ms
Timer1.initialize(1000);
Timer1.attachInterrupt(timerIsr); 
  
last = -1;
target_temp = MIN_TEMP;

pinMode(HEATER_PIN, OUTPUT);
analogWrite(HEATER_PIN, 0 );
}
 
void loop()
{
  target_temp += encoder->getValue();

  if( target_temp < MIN_TEMP ) 
    target_temp = MIN_TEMP;
  if( target_temp > MAX_TEMP )
    target_temp = MAX_TEMP;
    
  if (target_temp != last) {
    last = target_temp;
    Serial.print("Target Temp Value: ");
    Serial.println(target_temp);

    lcd.setCursor(0,0);
    lcd.print("Target T:");
    lcd.print( target_temp );

    lcd.setCursor(13,0);
    lcd.print( is_on ? "ON " : "OFF");
  }
  
  ClickEncoder::Button b = encoder->getButton();
  if (b != ClickEncoder::Open) {
    Serial.print("Button: ");
    #define VERBOSECASE(label) case label: Serial.println(#label); break;
    switch (b) {
      VERBOSECASE(ClickEncoder::Pressed);
      VERBOSECASE(ClickEncoder::Held)
      VERBOSECASE(ClickEncoder::Released)
      VERBOSECASE(ClickEncoder::Clicked)
      case ClickEncoder::DoubleClicked:
          Serial.println("");
          is_on = !is_on;
          Serial.print(" Dehumidifier is ");
          Serial.println(is_on ? "on" : "off");
          lcd.setCursor(13,0);
          lcd.print( is_on ? "ON " : "OFF");
        break;
    }
  }   
  
  if( readDHT == true )
  {
    float h = dht.readHumidity();
    float t = dht.readTemperature();
    
    if (isnan(h) || isnan(t)) {
      lcd.setCursor(0,0);
      lcd.print("Failed to read");
      lcd.setCursor(0,1);
      lcd.print("from DHT sensor!");
      Serial.println("Failed to read from DHT sensor!");
    } else {
      lcd.setCursor(0,1);
      lcd.print("H:");
      lcd.print(h);
      lcd.setCursor(9,1);
      lcd.print("T:");
      lcd.print(t);
  
      Serial.print("Humidity: "); 
      Serial.print(h);
      Serial.print(" %\t");
      Serial.print("Temprature: "); 
      Serial.print(t);
      Serial.println(" *C ");
    }
    if(is_on)
    {      
      if( target_temp > t )
      {
        int pwm_val = (target_temp-t)*3 + BASE_PWM;
        Serial.print("PWM Value:");
        Serial.println(pwm_val);
        analogWrite( HEATER_PIN, pwm_val );
      }
      else
      {
        analogWrite( HEATER_PIN, 0 );
        Serial.println("PWM Value:0");
      }
    }
    else
    {
      analogWrite( HEATER_PIN, 0 );
      Serial.println("PWM Value:0");         
    }
    readDHT = false;
  }  
}

