Hid keyboard;
HidMsg msg;
if(!keyboard.openKeyboard(0)) me.exit();
<<< "keyboard '" + keyboard.name() + "' ready", "" >>>;
0 => int endFlag;

Bass b;
Melody m;
// Melody m2;
// Melody m3;
// Melody m4;
// Melody m5;

[
	[0, 4, 7],
	[2, 5, 9],
	[4, 7, 11],
	[5, 9, 12],
	[7, 11, 14],
	[9, 12, 16],
	[11, 14, 17]
] @=> int chords[][];

1 => int key;

500::ms => dur beat;

Std.srand(2);

spork ~ kbListener();
while (true) {
	// Math.random2(0, 6) => int chordNum;
	randWeight([5, 3, 4, 5, 5, 4, 3]) => int chordNum;
	Math.random2(1,4) => int numBeats;
	
	runBar(chordNum, numBeats);

	if (endFlag) {
		Math.random2(1,4) => numBeats;
		runBar(3, numBeats);
		Math.random2(1,4) => numBeats;
		runBar(4, numBeats);
		// Math.random2(1,4) => numBeats;
		// runBar(0, numBeats);
		endSong(0, 4);
		me.exit();
	}
}

fun void runBar(int chordNum, int numBeats) {
	<<< numBeats, chordNum >>>;

	spork ~ m.play(chordNum, numBeats, 4);
	// spork ~ m2.play(chordNum, numBeats, 5);
	// spork ~ m3.play(chordNum, numBeats, 6);
	// spork ~ m4.play(chordNum, numBeats, 4);
	// spork ~ m5.play(chordNum, numBeats, 3);
	b.play(chordNum, numBeats);
}

fun void endSong(int chordNum, int numBeats) {
	<<< "end:", numBeats, chordNum >>>;

	spork ~ m.end(chordNum, numBeats, 4);
	// spork ~ m2.end(chordNum, numBeats, 5);
	// spork ~ m3.end(chordNum, numBeats, 6);
	// spork ~ m4.end(chordNum, numBeats, 4);
	// spork ~ m5.end(chordNum, numBeats, 3);
	b.end(chordNum, numBeats);
}


fun void kbListener() {
	while (!endFlag) {
		keyboard => now;

		while (keyboard.recv(msg)) {
			if (msg.isButtonDown()) {
				<<< "down:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
				if (msg.which == 16) {
					1 => endFlag;
					// keyboard.closeKeyboard();
				}
			} 
		}
	}
}

class Melody {
	Wurley w => Gain g => dac;
	g.gain(0.1);	

	float durations[0];

	fun void play(int chordNum, int numBeats, int octave) {
		genDurations(numBeats);
		for (0 => int i; i < durations.cap(); i++) {
			w.freq(Std.mtof(chords[chordNum][Math.random2(0,2)] + (12 * octave) + key));
			w.noteOn(1);
			(beat * durations[i]) => now;
			w.noteOff(0);
		}
		// <<< "m done" >>>;
	}

	fun void end(int chordNum, int numBeats, int octave) {
		w.freq(Std.mtof(chords[chordNum][Math.random2(0,2)] + (12 * octave) + key));
		w.noteOn(1);
		(beat * numBeats) => now;
		w.noteOff(0);
	}

	fun void genDurations(int numBeats) {
		durations.clear();
		0 => float i;

		while (i < numBeats) {
			(Math.random2(1, ((numBeats * 4) - (i * 4)) $ int) * 0.25) => float toAdd;
			toAdd +=> i;
			durations << toAdd;
		}
		
	}
}

class Bass {
	Wurley w1 => Gain g => dac;
	Wurley w2 => g => dac;
	Wurley w3 => g => dac;
	g.gain(0.05);


	fun void play(int chordNum, int numBeats) {

		// w1.freq(Std.mtof(chords[chordNum][0] + 36 + key));
		// w1.noteOn(1);
		// w2.freq(Std.mtof(chords[chordNum][1] + 36 + key));
		// w2.noteOn(1);
		// w3.freq(Std.mtof(chords[chordNum][2] + 36 + key));
		// w3.noteOn(1);

		// (beat * numBeats) => now;

		for (0 => int i; i < numBeats; i++) {
			w1.freq(Std.mtof(chords[chordNum][Math.random2(0,2)] + 24 + key));
			w1.noteOn(1);
			beat => now;
			w1.noteOff(0);
		}
		// <<< "b done" >>>;
	}

	fun void end(int chordNum, int numBeats) {
		for (0 => int i; i < (numBeats - 1); i++) {
			w1.freq(Std.mtof(chords[chordNum][Math.random2(0,2)] + 24 + key));
			w1.noteOn(1);
			beat => now;
			w1.noteOff(0);
		}
		w1.freq(Std.mtof(chords[chordNum][0] + 24 + key));
		w1.noteOn(1);
		beat => now;
		w1.noteOff(0);
	}
}

fun int randWeight(int weights[]) {
	0 => int sum;
	for (0 => int i; i < weights.cap(); i++) {
		weights[i] +=> sum;
	}
	Math.random2(0, sum) => int rnd;

	for(0 => int i; i < weights.cap(); i++) {
		if(rnd < weights[i])
			return i;
		weights[i] -=> rnd;
	}

	return 0;
}
