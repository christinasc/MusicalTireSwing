#include "testApp.h"
#include <stdlib.h> /* required for randomize() and random() */
#import <time.h>

// Tire Swing app, sounds only
//--------------------------------------------------------------
//--------------------------------------------------------------
//float cycleTime = 312;
// 5 minutes, 12 secondsper cycle = 60*5  +12 = 312 seconds

float cycleTime = 312; // 30 seconds per cycle
float timeLapsed = 0;
float currTime =0;
int roundsPlayed =0;
//--------------------------------------------------------------
//--------------------------------------------------------------

float minAcc = 1.0;
float rotZmax = 0.0;  // max Z rotation experienced
float lastZ = 0.0;
float currentZ = 0.0;

float accOffset = 1.0;
float rollOffset = 1.5;
float pitchOffset = 1.0;

// minimum motion required for triggering sound
// (multiplier, increase for spread out sounds)
float minMotion = 2.0;
float maxMotion = 20; // 40; // max reading on Z axis
bool brazilForward = true;

////////////******** WARP FACTOR ************////////////
float speedFactor = 1.25f; //  0.5f; // adjust up for more distortion 0.2 - 1.5, -1
float volFactor = 10.0f;  // adjust up for louder sound.
////////////********************////////////

int currentPongPosition = 0;

//--------------------------------------------------------------
void testApp::setup(){	
    
    currentTrack = 1; // current track #
    
    ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
    NSLog(@"Entering testApp::setup");
    //iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	//this is to scale down the example for the iphone screen
	appIphoneScale = 1.0;
    //////// GYRO
    enableGyro();
    // initialize the accelerometer
	ofxAccelerometer.setup();
    // fonts
    font.loadFont("Sudbury_Basin_3D.ttf", 35);
	fontSmall.loadFont("Sudbury_Basin_3D.ttf", 18);
    loadTracks();
    ofRegisterTouchEvents(this);
}


void testApp::timeUpdate() {
    currTime = ofGetElapsedTimef();
    
    if (currentTrack != 0) {
        if (currTime > (timeLapsed + cycleTime) ) { // load next set of tracks after time exceeded
            if (currentTrack < maxTracks ) {
                currentTrack++;  // increment track if we haven't reached the max yet
            } else if (currentTrack == maxTracks) { // if we have reached max tracks, go back to 1st
                currentTrack = 1;
                roundsPlayed++;
            }
            timeLapsed = currTime;
        }
    } // end if currentTrack
}


void testApp::effectFactors() {
    Yfactor = 0;
    Xfactor = 0;
    Yfactor = int(fabs(roll-rollOffset)/minMotion);
    Xfactor = int(fabs(pitch)*minMotion)+pitchOffset;
    // NSLog(@"XFactor: %i, YFactor: %i", Xfactor, Yfactor);
    // case Xfactor > min, >2x, >4x, : 4.0, 8, 12 : 1 ,2 ,3
}



void testApp::sensorUpdate() {
    accX = fabs(ofxAccelerometer.getForce().x);  // net positive value of acceleration
    accY = fabs(ofxAccelerometer.getForce().y);
    accZ = fabs(ofxAccelerometer.getForce().z);
    
    getDeviceGLRotationMatrix();
    
    // NSLog(@" Roll yaw pitch: [%f, %f, %f]:", roll, yaw, pitch);
    // NSLog(@"Acc [X,Y,Z]: [%f, %f, %f]", accX, accY, accZ);
    
    float diffZ = (int)yaw - (int)lastZ;
    pctZ = fabs(diffZ)/(int)lastZ*100;
    
    if (fabs(yaw) > 0.001 ) {
        currentZ = fabs(yaw);
        if (pctZ > 30) { // if change is greater than 30 percent, then shift
            lastZ = currentZ; // distance from Zero is what matters.
            speed = 1.0f + ((int)currentZ / maxMotion*speedFactor);
            vol = 0.5f + ((int)currentZ/ maxMotion*volFactor);
        }
    }
    // if current yaw greatest, then set it to be so.
    if (fabs(yaw) > rotZmax) {
        rotZmax = fabs(yaw);
        //NSLog(@"Max Z = %.2f", rotZmax);
    }
   // NSLog(@"Yaw: %f Speed: %f, Vol: %f", yaw, speed, vol);
    
    effectFactors();  // roll and pitch calculations
    
}


void testApp::playBaseTracks() {
    
    //string tname = trackNameTags[currentTrack];
    
    switch(currentTrack) {     //// TRACKS
        case 1: // CARNIVAL
            carnivalEffect();
            break;
        case 2: // PACMAN
            pacmanEffect();
            break;
        case 3: // Phones - loud pipes
            phonesEffect();
            break;
       // case 4:  // Brazilian Funk
       //     brazilEffect();
       //     break;
        case 4: //  Super Mario
            marioEffect();
            break;
        case 5: // Grapes
            grapesEffect();
            break;
        case 6: // Drum kit
            drumsEffect();
            break;
        case 7: // Pong
            pongEffect();
            break;
        case 0: // stop all sounds
            stopSounds();
            NSLog(@" track : default %i", currentTrack);
            break;
            
    } // end Switch (currentTrack)
 
}


void testApp::carnivalEffect() {
    // NSLog(@" track #1");
    ping.stop();
    pong.stop();
    miss.stop();
    level1.stop(); // stop last continous sound in sequence
    
    carnival.setSpeed(speed);
    carnival.setVolume(vol);
    
    if (!carnival.getIsPlaying()) {
        carnival.play();
    }
    
    switch ( Xfactor) {
        case 1:
            NSLog(@"Track 1: XFactor case 1: %i", Xfactor);
            one.setVolume(0.6f);
            one.play();
            break;
        case 2:
            NSLog(@"Track 1: XFactor case 2: %i", Xfactor);
            two.setVolume(0.8);
            two.play();
            break;
        case 3:
            NSLog(@"Track 1: XFactor case 3: %i", Xfactor);
            three.setVolume(1.0f);
            three.play();
            break;
        default:
            break;
    }
    
    switch (Yfactor)  {
        case 1:
            NSLog(@"Track 1:YFactor case 1: %i", Yfactor);
            four.setVolume(0.6f);
            four.play();
            break;
        case 2:
            NSLog(@"Track 1:YFactor case 2: %i", Yfactor);
            five.setVolume(0.8f);
            five.play();
            break;
        case 3:
            NSLog(@"Track 1:YFactor case 3: %i", Yfactor);
            six.setVolume(1.0f);
            six.play();
            break;
        default:
            break;
    }
    
    // acceleration bumps track 1
    if ((accX-accOffset) > minAcc)  {
        NSLog(@"Track 1: Acc X: %f", accX);
        four.setVolume(0.6f);
        four.play();
    }
    if (accY > minAcc)  {
        NSLog(@"Track 1: AccY:  %f", accY);
        five.setVolume(0.8f);
        five.play();
    }
    if (accZ > 2*minAcc) {
        NSLog(@"Track 1: AccZ: %f", accZ);
        six.setVolume(1.0f);
        six.play();
    }
    
}


void testApp::pacmanEffect() {
    NSLog(@" track #2: %i", currentTrack);

    carnival.stop();
    
    pacman.setSpeed(1.0);
    pacman.setVolume(0.1f);
    
    pac_eating.setVolume(0.6f);

//    NSLog(@" Pacman : %f");
       
    if (!pac_eating.getIsPlaying()) {
        //pac_eating.setSpeed(speed);
        pac_eating.setSpeed(1.0f);
        pac_eating.play();
        pacman.play();
    }
    
    
    switch ( Xfactor) {
        case 1:
            pac_siren3.setVolume(0.8f);
            pac_siren3.play();
            break;
        case 2:
            pac_pellet.setVolume(0.8f);
            pac_pellet.play();
            break;
        case 3:
             pac_score2.setVolume(1.0f);
             pac_score2.play();
            break;
        default:
            break;
            
    }
    switch (Yfactor)  {
        case 1:
            pac_eatone.setVolume(0.6f);
            pac_eatone.play();
            pac_chase.setVolume(0.6f);
            pac_chase.play();
            break;
        case 2:
           pac_pellet2.setVolume(0.8f);
           pac_pellet2.play();
            break;
        case 3:
            pac_score.setVolume(1.0f);
            pac_score.play();
            break;
        default:
            break;
    }
    
    if ((accX-accOffset) > minAcc)  {
        pac_siren1.setVolume(0.8f);
        pac_siren1.play();
    }
    if (accY > minAcc)  {
        pac_ateghost.setVolume(0.8f);
        pac_ateghost.play();
    }
    if (accZ > 2*minAcc) {
        pac_bells.setVolume(1.0f);
        pac_bells.play();
    }
}

void testApp::phonesEffect() {
    NSLog(@" track #3 %i", currentTrack);
    
    pacman.stop();
    pac_eating.stop();
    
   // beats4.setSpeed(speed);
    
    beats4.setSpeed(1.0f);  // set speed constant for base
    beats4.setVolume(vol);
    
    if (!beats4.getIsPlaying()) {
        beats4.play();
    }

    switch ( Xfactor) {
        case 1:
            // NSLog(@"Track 3: XFactor case 1: %i", Xfactor);
            one4.setVolume(0.6f);
            one4.play();
            break;
        case 2:
            //   NSLog(@"Track 3: XFactor case 2: %i", Xfactor);
            two4.setVolume(0.8f);
            two4.play();
            break;
        case 3:
            // NSLog(@"Track 3: XFactor case 3: %i", Xfactor);
            three4.setVolume(1.0f);
            three4.play();
            break;
        default:
            break;
            
    }
    switch (Yfactor)  {
        case 1:
            //  NSLog(@"Track 3: YFactor case 1: %i", Yfactor);
            four4.setVolume(0.6f);
            four4.play();
            break;
        case 2:
            //  NSLog(@"Track 3: YFactor case 2: %i", Yfactor);
            five4.setVolume(0.8f);
            five4.play();
            break;
        case 3:
            //  NSLog(@"Track 3: YFactor case 3: %i", Yfactor);
            six4.setVolume(1.0f);
            six4.play();
            break;
        default:
            break;
            
    }
    
    if ((accX-accOffset) > minAcc)  {
        //  NSLog(@"Track 3: Acc X: %i", accX);
        four4.setVolume(0.8f);
        four4.play();        
    }
    if (accY > minAcc)  {
        //  NSLog(@"Track 3: Acc Y case 2: %i", accY);
        five4.setVolume(0.8f);
        five4.play();        
    }
    if (accZ > 2*minAcc) {
        //  NSLog(@"Track 3: Acc Z case 3: %i", accZ);
        six4.setVolume(1.0f);
        six4.play();        
    }
}


void testApp::brazilEffect() {
    NSLog(@" track #4 %i", currentTrack);

    beats4.stop();
    
    brazil1.setSpeed(speed);
    brazil1.setVolume(vol);  // 0.1f volume at 10% maximum, 1.0 is maximum
    
    if ((int)yaw > 0) {
        //  PLAY IT forward -
        if (!brazil1.getIsPlaying()) {
            brazil2.stop();
            brazil1.play();
        }
    } else if (yaw < -1) {
        // PLAY IT backward
        if (!brazil2.getIsPlaying()) {
            brazil1.stop();
            brazil2.play();
        }
    } // end else if
    
    
    switch ( Xfactor) {
        case 1:
            brazilE1.setVolume(0.6f);
            brazilE1.play();
            break;
        case 2:
            brazilE2.setVolume(0.8f);
            brazilE2.play();
            break;
        case 3:
            brazilE3.setVolume(1.0f);
            brazilE3.play();
            break;
        default:
            break;
            
    }
    switch (Yfactor)  {
        case 1:
            brazilE4.setVolume(0.6f);
            brazilE4.play();
            break;
        case 2:
            brazilE5.setVolume(0.8f);
            brazilE5.play();
            break;
        case 3:
            brazilE6.setVolume(1.0f);
            brazilE6.play();
            break;
        default:
            break;
    }
    
    if ((accX-accOffset) > minAcc)  {
        brazilE7.setVolume(0.8f);
        brazilE7.play();
    }
    if (accY > minAcc)  {
        brazilE8.setVolume(0.8f);
        brazilE8.play();
    }
    if (accZ > 2*minAcc) {
        brazilE9.setVolume(1.0f);
        brazilE9.play();
    }

    
}

void testApp::marioEffect() {
    NSLog(@" track #5 %i", currentTrack);

   // brazil1.stop();
   // brazil2.stop();
    
    beats4.stop();

    beats5.setSpeed(speed);
    beats5.setVolume(vol);
    if (!beats5.getIsPlaying()) {
        beats5.play();
    }
    
    switch ( Xfactor) {
        case 1:
            one5.setVolume(0.6f);
            one5.play();
            break;
        case 2:
            two5.setVolume(0.8f);
            two5.play();
            break;
        case 3:
            three5.setVolume(1.0f);
            three5.play();
            break;
        default:
            break;
            
    }
    switch (Yfactor)  {
        case 1:
            four5.setVolume(0.6f);
            four5.play();
            break;
        case 2:
            five5.setVolume(0.8f);
            five5.play();
            break;
        case 3:
            one5.setVolume(1.0f);
            one5.play();
            break;
        default:
            break;
    }
    
    if (accX-accOffset > minAcc)  {
        four5.setVolume(0.8f);
        four5.play();
    }
    if (accY > minAcc)  {
        five5.setVolume(0.8f);
        five5.play();
    }
    if (accZ > 2*minAcc) {
        two5.setVolume(1.0f);
        two5.play();
    }
}



void testApp::grapesEffect() {
    NSLog(@" track #6 %i", currentTrack);

    beats5.stop();
    
    grapes.setSpeed(speed);
    grapes.setVolume(vol);
    
    if (!grapes.getIsPlaying()) {
        grapes.play();
    }
    
    switch ( Xfactor) {
        case 1:
            grapesE1.setVolume(0.6f);
            grapesE1.play();
            break;
        case 2:
            grapesE2.setVolume(0.8f);
            grapesE2.play();
            break;
        case 3:
            grapesE3.setVolume(1.0f);
            grapesE3.play();
            break;
        default:
            break;
            
    }
    switch (Yfactor)  {
        case 1:
            grapesE4.setVolume(0.6f);
            grapesE4.play();
            break;
        case 2:
            grapesE5.setVolume(0.8f);
            grapesE5.play();
            break;
        case 3:
            grapesE6.setVolume(1.0f);
            grapesE6.play();
            break;
        default:
            break;
    }
    
    if (accX-accOffset > minAcc)  {
        grapesE7.setVolume(0.8f);
        grapesE7.play();
    }
    if (accY > minAcc)  {
        grapesE8.setVolume(0.8f);
        grapesE8.play();
    }
    if (accZ > 2*minAcc) {
        grapesE9.setVolume(1.0f);
        grapesE9.play();
    }
}

void testApp::drumsEffect() {
    NSLog(@" track #7 %i", currentTrack);

    grapes.stop();
        
    level1.setSpeed(speed);
    level1.setVolume(vol);
    if (!level1.getIsPlaying()) {
        level1.play();
    }
    
    switch ( Xfactor) {
        case 1:
            break;
        case 2:
            level2.setVolume(0.8f);
            level2.play();
            break;
        case 3:
            level3.setVolume(1.0f);
            level3.play();
            break;
        default:
            break;
            
    }
    switch (Yfactor)  {
        case 1:
            break;
        case 2:
            level4.setVolume(0.5f);
            level4.play();
            break;
        case 3:
            level4.setVolume(1.0f);
            level4.play();
            break;
        default:
            break;
    }    
    
}

void testApp::pongEffect() {

    NSLog(@" track #8 %i", currentTrack);
    stopDrums();
    
    ping.setVolume(1.0f);
    pong.setVolume(1.0f);

    // currentPongPosition = 0;
    
    float dotproduct = (roll-1.5)*pitch;
    int lastPongPosition = currentPongPosition;
    
    if (dotproduct > 0.025) {
        currentPongPosition = 1;
    }
    if (dotproduct < -0.025) {
        currentPongPosition = -1;
    }
    
    int diffPong = currentPongPosition - lastPongPosition;
    
    if (diffPong > 0) {
        
        if (!ping.getIsPlaying()) {
            pong.stop();
            ping.play();
        }
    } else if (diffPong < 0){
        
        if (!pong.getIsPlaying()) {
            ping.stop();
            pong.play();
        }
    }
   
}



void testApp::stopDrums() {
    level1.stop();
    level2.stop();
    level3.stop();
    level4.stop();
}


//--------------------------------------------------------------
void testApp::update(){
	ofBackground(255,255,255);
    timeUpdate();
	sensorUpdate();
    playBaseTracks();
    
    // ***** - this goes at the end of this method!
	// update the sound playing system:
    ofSoundUpdate();
}


//--------------------------------------------------------------
void testApp::draw(){
    
    ofScale(appIphoneScale, appIphoneScale, 1.0);
    
    char tempStr[255];
    
    // draw the background colors:
    float widthDiv = ofGetWidth() / 3.0f;
    ofSetHexColor(0xeeeeee);
    ofRect(0,0,widthDiv,ofGetHeight());
    ofSetHexColor(0xffffff);
    ofRect(widthDiv,0,widthDiv,ofGetHeight());
    ofSetHexColor(0xdddddd);
    ofRect(widthDiv*2,0,widthDiv,ofGetHeight());
    
    // ------------------------------- TIME ELASPED
    ofSetHexColor(0x000000);
    sprintf(tempStr, "TIME %f\nelapsedTime: %f\n track#: %d \nround#: %d",
            currTime, timeLapsed, currentTrack, roundsPlayed);
    ofDrawBitmapString(tempStr, widthDiv*2+5,ofGetHeight()-50);
    
    //---------------------------------- Gyro on Screen data:
    ofSetHexColor(0x000000);
    sprintf(tempStr, "GYRO\nroll: %f\nyaw: %f \npitch: %f", roll, yaw, pitch);
    ofDrawBitmapString(tempStr, widthDiv+5,ofGetHeight()-50);
    
    //---------------------------------- Acc on Screen data:
    ofSetHexColor(0x000000);
    sprintf(tempStr, "ACC\nX: %f\nY: %f \nZ: %f", accX, accY,accZ);
    ofDrawBitmapString(tempStr,5,ofGetHeight()-50);
    
    //---------------------------------- pause:
    ofSetHexColor(0x000000);
    fontSmall.drawString("Stop", widthDiv+50,150);
    trackNames();
    
    //---------------------------------- >> Advance forward:
    ofSetHexColor(0x000000);
    font.drawString(">>", widthDiv*2+50,150);
}


void testApp::trackNames() {
    int val = currentTrack-1;
    
    if (currentTrack <= maxTracks) {
        if (val >= 0) {
            font.drawString(trackNameTags[val], 100,50);
        } else if (val == -1 ) {
            font.drawString("NO TRACK", 100,50);
        }
    }
}


//--------------------------------------------------------------
void testApp::exit(){
    
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
	if( touch.id == 0 ){
		float widthStep = ofGetWidth() / 3.0f;
        if (touch.x >= widthStep && touch.x < widthStep*2){  // pause
            NSLog(@" STOP ");
            currentTrack = 0;
            
		} else if (touch.x >= widthStep*2){  // forward one track
            NSLog(@" FORWARD ");
            if (currentTrack < maxTracks) {
                currentTrack++;
                timeLapsed = currTime;  // set the timeLasped to be currentTime, count from zero
            } else { currentTrack = 1; }
		}
	}
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){

}


void testApp::enableGyro() {
	motionManager = [[CMMotionManager alloc] init];
	referenceAttitude = nil;
	
	CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
	CMAttitude *attitude = deviceMotion.attitude;
	referenceAttitude = [attitude retain];
	[motionManager startDeviceMotionUpdates];
    
    if (referenceAttitude){
        NSLog(@" Enabling Gyro");
    }
    
}


void testApp::getDeviceGLRotationMatrix() {
	CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
	CMAttitude *attitude = deviceMotion.attitude;
	
	if ( referenceAttitude != nil ) {
		[attitude multiplyByInverseOfAttitude:referenceAttitude];
	}
	roll	= attitude.roll;
	pitch	= attitude.pitch;
	yaw	= attitude.yaw;
}


//--------------------------------------------------------------
void testApp::lostFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    
}


void testApp::stopSounds() {  // This method silences EVERYTHING, dont use it in the switch statement
    ofSoundStopAll();
    carnival.stop();
    pacman.stop();
    beats4.stop();
    brazil1.stop();
    brazil2.stop();
    beats5.stop();
    grapes.stop();
    ping.stop();
    pong.stop();
    level1.stop();
}


void testApp::loadTracks() {
    
    // Carnival
    carnival.loadSound(tracks[0]);
    one.loadSound(tracks[1]);
    two.loadSound(tracks[2]);
    three.loadSound(tracks[3]);
    four.loadSound(tracks[4]);
    five.loadSound(tracks[5]);
    six.loadSound(tracks[6]);
    
    carnival.setVolume(0.20f);
	carnival.setMultiPlay(false);  // do not allow multitracks
    
    one.setMultiPlay(false);
    two.setMultiPlay(false);
    three.setMultiPlay(false);
    four.setMultiPlay(false);
    four.setMultiPlay(false);
    six.setMultiPlay(false);
    
    // Pacman
    pacman.loadSound(tracks2[0]);
    pacman.setVolume(0.20f);
	pacman.setMultiPlay(false); // do not allow multitracks
    
    pac_goodby.loadSound(tracks2[1]);
    pac_ateghost.loadSound(tracks2[2]);
    pac_bells.loadSound(tracks2[3]);
    pac_chase.loadSound(tracks2[4]);
    pac_die.loadSound(tracks2[5]);
    pac_eating.loadSound(tracks2[6]);
    pac_eatone.loadSound(tracks2[7]);
    pac_pellet.loadSound(tracks2[8]);
    pac_pellet2.loadSound(tracks2[9]);
    pac_score.loadSound(tracks2[10]);
    pac_score2.loadSound(tracks2[11]);
    pac_siren1.loadSound(tracks2[12]);
    pac_siren2.loadSound(tracks2[13]);
    pac_siren3.loadSound(tracks2[14]);
    pac_siren4.loadSound(tracks2[15]);
    pac_siren5.loadSound(tracks2[16]);

    pac_ateghost.setMultiPlay(false);
    pac_bells.setMultiPlay(false);
    pac_chase.setMultiPlay(false);
    pac_die.setMultiPlay(false);
    pac_eating.setMultiPlay(false);
    pac_eatone.setMultiPlay(false);
    pac_pellet.setMultiPlay(false);
    pac_pellet2.setMultiPlay(false);
    pac_score.setMultiPlay(false);
    pac_score2.setMultiPlay(false);
    pac_siren1.setMultiPlay(false);
    pac_siren2.setMultiPlay(false);
    pac_siren3.setMultiPlay(false);
    pac_siren4.setMultiPlay(false);
    pac_siren5.setMultiPlay(false);

    
    // LOUD PIPES + phone sound effect
    beats4.loadSound(tracks3[0]);
    one4.loadSound(tracks3[1]);
    two4.loadSound(tracks3[2]);
    three4.loadSound(tracks3[3]);
    four4.loadSound(tracks3[4]);
    five4.loadSound(tracks3[5]);
    six4.loadSound(tracks3[6]);
    
    
    beats4.setMultiPlay(false);  // do not allow multitracks
    one4.setMultiPlay(false);
    two4.setMultiPlay(false);
    three4.setMultiPlay(false);
    four4.setMultiPlay(false);
    five4.setMultiPlay(false);
    six4.setMultiPlay(false);
    
    
    // brazil + wood shop effects
    brazil1.loadSound(tracks5[0]);
    brazil2.loadSound(tracks5[1]);
    brazil1.setVolume(0.20f);
    brazil2.setVolume(0.20f);
    
    brazilE1.loadSound(tracks5[2]);
    brazilE2.loadSound(tracks5[3]);
    brazilE3.loadSound(tracks5[4]);
    
    brazilE4.loadSound(tracks5[5]);
    brazilE5.loadSound(tracks5[6]);
    brazilE6.loadSound(tracks5[7]);
    
    brazilE7.loadSound(tracks5[8]);
    brazilE8.loadSound(tracks5[9]);
    brazilE9.loadSound(tracks5[10]);
    
    
    // mario + game sound effects
    beats5.loadSound(tracks6[0]);
    one5.loadSound(tracks6[1]);
    two5.loadSound(tracks6[2]);
    three5.loadSound(tracks6[3]);
    four5.loadSound(tracks6[4]);
    five5.loadSound(tracks6[5]);
    
    beats5.setVolume(0.20f);
    
    
    // grapes + weather effects
    grapes.loadSound(tracks7[0]);
    grapes.setVolume(0.20f);
    
    grapesE1.loadSound(tracks7[1]);
    grapesE2.loadSound(tracks7[2]);
    grapesE3.loadSound(tracks7[3]);
    
    grapesE4.loadSound(tracks7[4]);
    grapesE5.loadSound(tracks7[5]);
    grapesE6.loadSound(tracks7[6]);
    
    grapesE7.loadSound(tracks7[7]);
    grapesE8.loadSound(tracks7[8]);
    grapesE9.loadSound(tracks7[9]);
    

    // Pong
    ping.loadSound(tracks8[0]);
    ping.setVolume(1.0f);
    ping.setMultiPlay(false);
    
    pong.loadSound(tracks8[1]);
    pong.setVolume(1.0f);
    pong.setMultiPlay(false);
    
    miss.loadSound(tracks8[2]);
    miss.setVolume(1.0f);
    miss.setMultiPlay(false);

    
    // Drumkit
    level1.loadSound(tracks9[0]);
    level1.setVolume(0.20f);
    level1.setMultiPlay(false);

    level2.loadSound(tracks9[1]);
    level2.setVolume(0.20f);
    level2.setMultiPlay(false);

    level3.loadSound(tracks9[2]);
    level3.setVolume(0.20f);
    level3.setMultiPlay(false);

    level4.loadSound(tracks9[3]);
    level4.setVolume(0.20f);
    level4.setMultiPlay(false);

}


