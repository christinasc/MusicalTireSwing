#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreMotion/CMMotionManager.h>


class testApp : public ofxiPhoneApp{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
    
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
	
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
		
    
        // Gyro define here
        void enableGyro();
        void getDeviceGLRotationMatrix();
   
        CMMotionManager *motionManager;
        CMAttitude *referenceAttitude;

        float roll, pitch, yaw;
        float accX, accY, accZ;  // acceleration bumps
    
        float pctZ, speed, vol;
        int Yfactor;
        int Xfactor;
    
        // sound track counters
        int currentTrack;
        static const int maxTracks = 7;    //// Total number of TRACKS PLAYABLE
    
    // order matters - must shut previous track in sequence
    // off before playing current track
    
        string trackNameTags[maxTracks] = {
            "CARNIVAL",
            "PACMAN",
            "PHONES",
          //  "BRAZILIAN FUNK",
            "SUPER MARIO",
            "GRAPES",
            "DRUMS",
            "PONG"
        };

    
        ofTrueTypeFont font;
        ofTrueTypeFont fontSmall;
    
        float synthPosition;
        float appIphoneScale;
    
        // carnival
        ofSoundPlayer carnival;
        ofSoundPlayer  one;
        ofSoundPlayer  two;
        ofSoundPlayer  three;
        ofSoundPlayer  four;
        ofSoundPlayer  five;
        ofSoundPlayer  six;
        ofSoundPlayer  seven;
        ofSoundPlayer  eight;
    
        // pacman
        ofSoundPlayer pacman;
        ofSoundPlayer pac_goodby;
        ofSoundPlayer pac_ateghost;
        ofSoundPlayer pac_bells;
        ofSoundPlayer pac_chase;
        ofSoundPlayer pac_die;
        ofSoundPlayer pac_eating;
        ofSoundPlayer pac_eatone;
        ofSoundPlayer pac_pellet;
        ofSoundPlayer pac_pellet2;
        ofSoundPlayer pac_score;
        ofSoundPlayer pac_score2;
        ofSoundPlayer pac_siren1;
        ofSoundPlayer pac_siren2;
        ofSoundPlayer pac_siren3;
        ofSoundPlayer pac_siren4;
        ofSoundPlayer pac_siren5;
        
        // phones - loud pipes
        ofSoundPlayer  beats4;
        ofSoundPlayer  one4;
        ofSoundPlayer  two4;
        ofSoundPlayer  three4;
        ofSoundPlayer  four4;
        ofSoundPlayer  five4;
        ofSoundPlayer  six4;
        ofSoundPlayer  seven4;
        ofSoundPlayer  eight4;
        
        
        // brazilian funk
        ofSoundPlayer  brazil1; // base soundtracks
        ofSoundPlayer  brazil2; // base soundtracks
        
        ofSoundPlayer  brazilE1; // Effects
        ofSoundPlayer  brazilE2;
        ofSoundPlayer  brazilE3;
        
        ofSoundPlayer  brazilE4;
        ofSoundPlayer  brazilE5;
        ofSoundPlayer  brazilE6;
        
        ofSoundPlayer  brazilE7;
        ofSoundPlayer  brazilE8;
        ofSoundPlayer  brazilE9;
        
    
        // mario soundtrack
        ofSoundPlayer  beats5;
        ofSoundPlayer  one5;
        ofSoundPlayer  two5;
        ofSoundPlayer  three5;
        ofSoundPlayer  four5;
        ofSoundPlayer  five5;
    
        
        // grapes
        ofSoundPlayer grapes;
        
        ofSoundPlayer grapesE1; // Effects
        ofSoundPlayer grapesE2;
        ofSoundPlayer grapesE3;
        
        ofSoundPlayer grapesE4;
        ofSoundPlayer grapesE5;
        ofSoundPlayer grapesE6;
        
        ofSoundPlayer grapesE7;
        ofSoundPlayer grapesE8;
        ofSoundPlayer grapesE9;

        // pong
        ofSoundPlayer  ping;
        ofSoundPlayer  pong;
        ofSoundPlayer  miss;

        // Drumkit
        ofSoundPlayer  level1;
        ofSoundPlayer  level2;
        ofSoundPlayer  level3;
        ofSoundPlayer  level4;

    
        static const int MAXITEMS = 18;
    
        string tracks[MAXITEMS] = {
        "sounds/cartoon/Estudaintina.caf", // base track
        "sounds/34Voces.caf",
        "sounds/27Redoble.caf",
        "sounds/SEcaf/71 Toy _ Single High Squeak.caf",
        "sounds/SEcaf/74 Train _ Steam _ Two Short Whistle Blasts.caf",
        "sounds/SEcaf/92 Whip _ Single Crack.caf",
        "sounds/SEcaf/23 Cash Register.caf"};

        string tracks2[MAXITEMS] = {
        "sounds/Pacman/introsong.caf",// intro song
        "sounds/Pacman/goodbye_song.caf", // bye song
        "sounds/Pacman/ate_ghost.caf",
        "sounds/Pacman/bells.caf",
        "sounds/Pacman/chasesiren.caf",
        "sounds/Pacman/die_sound.caf",
        "sounds/Pacman/eating.caf",
        "sounds/Pacman/eatone.caf",
        "sounds/Pacman/pellet.caf",
        "sounds/Pacman/pellet2.caf",
        "sounds/Pacman/score.caf",
        "sounds/Pacman/score2.caf",
        "sounds/Pacman/siren1.caf",
        "sounds/Pacman/siren2.caf",
        "sounds/Pacman/siren3.caf",
        "sounds/Pacman/siren4.caf",
        "sounds/Pacman/siren5.caf"
        };

    
    string tracks3[MAXITEMS] = {"sounds/loudpipes.caf", // base track
        "sounds/SEcaf/47 Telephone _ Antique _ Wind and Ring _ Phone.caf",
        "sounds/SEcaf/45 Telemetry _ Computer Readout _ Science Fiction _ Sci Fi.caf",
        "sounds/SEcaf/49 Telephone _ Domestic _ Dial Phone _ Ringing _ Phone.caf",
        "sounds/SEcaf/48 Telephone _ Cellular _ Button Beep _ Phone.caf",
        "sounds/SEcaf/51 Telephone _ Domestic _ Dial Phone _ Dial _ Phone.caf",
        "sounds/SEcaf/56 Telephone _ Internal _ Dial Tone _ Phone.caf",};

    
    string tracks5[MAXITEMS] = {"sounds/Tchukatchu.caf", // base track 1
        "sounds/FunkReverse.caf", // base track 2
        "sounds/SEcaf/66 Tool _ Nailer _ Single Nail Into Wood.caf",
        "sounds/SEcaf/62 Tool _ Drill _ Drill Hole.caf",
        "sounds/SEcaf/63 Tool _ Impact Wrench _ Remove Single Nut.caf",
        "sounds/SEcaf/67 Tool _ Saw _ Hand _ Cut Moulding.caf",
        "sounds/SEcaf/64 Tool _ Jack Hammer _ Running.caf",
        "sounds/SEcaf/61 Tool _ Chainsaw _ Start and Stop.caf",
        "sounds/SEcaf/65 Tool _ Metal Coupler _ Single Press.caf",
        "sounds/SEcaf/68 Tool _ Saw _ Hand _ Cut Plank.caf",
        "sounds/SEcaf/60 Tool _ Belt _ Drop to Ground.caf" };

    string tracks6[MAXITEMS] = {"sounds/Mario-caf/SuperMarioTheme.caf", // base track
        "sounds/Mario-caf/MarioGetCoins.caf",
        "sounds/Mario-caf/MarioJump.caf",
        "sounds/Mario-caf/MarioPauses.caf",
        "sounds/Mario-caf/MarioPipeWarp.caf",
        "sounds/Mario-caf/MarioPowerUp.caf" };
    
    string tracks7[MAXITEMS] = {"sounds/grapesIdunno.caf",  // base track
        "sounds/SEcaf/69 Torpedo _ Single Release Underwater _ Submarine.caf",
        "sounds/SEcaf/94 Whoosh _ Heavy Air Rush Whoosh By.caf",
        "sounds/SEcaf/81 Water _ Bubble _ Large Surface Bubble.caf",
        "sounds/SEcaf/82 Water _ Bubble _ Rapid Bubble Pop.caf",
        "sounds/SEcaf/85 Water _ Splash _ Rock Impact.caf",
        "sounds/SEcaf/82 Water _ Bubble _ Rapid Bubble Pop.caf",
        "sounds/SEcaf/86 Weather _ Lightning _ Close Strike and Rumble.caf",
        "sounds/SEcaf/82 Water _ Bubble _ Rapid Bubble Pop.caf"};

    string tracks8[MAXITEMS] = { // pong
        "sounds/Pong/ping.caf",
        "sounds/Pong/pong.caf",
        "sounds/Pong/miss.caf"
    };
    
    string tracks9[MAXITEMS] = { // drumkit
        "sounds/DrumKit/Level1.caf",
        "sounds/DrumKit/Level2.caf",
        "sounds/DrumKit/Level3.caf",
        "sounds/DrumKit/Level4.caf"
    };
    
        
    
    private:
        void timeUpdate();
        void sensorUpdate();
        void loadTracks();
        void stopSounds();
    
        void playBaseTracks(); // play base tracks
        void trackNames(); // track names
        void effectFactors();  // calculate effect factors
        
        void carnivalEffect();  // effects for each track
        void pacmanEffect();
        void phonesEffect();
        void brazilEffect();
        void marioEffect();
        void grapesEffect();
        void drumsEffect();
        void pongEffect();
    
        void stopDrums();
    
};


