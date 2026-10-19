SinOsc s => dac;
0 => s.gain;

SinOsc glass => dac;
SinOsc glassHigh => dac;
0 => glass.gain;
0 => glassHigh.gain;

// chord
TriOsc chord[3];
Gain master => dac;

for(0 => int i; i < chord.cap(); i++)
{
    chord[i] => master;
    1.0 / chord.cap() => chord[i].gain;
}
0.02 => master.gain;

SndBuf Fx1 => dac;
SndBuf Fx2 => dac;
SndBuf Fx3 => dac;
SndBuf Fx4 => dac;
SndBuf Fx5 => dac;

me.dir() + "audio/stereo_fx_01.wav" => Fx1.read;
me.dir() + "audio/stereo_fx_02.wav" => Fx2.read;
me.dir() + "audio/stereo_fx_03.wav" => Fx3.read;
me.dir() + "audio/stereo_fx_04.wav" => Fx4.read;
me.dir() + "audio/stereo_fx_05.wav" => Fx5.read;

Fx1.samples() => Fx1.pos;
Fx2.samples() => Fx2.pos;
Fx3.samples() => Fx3.pos;
Fx4.samples() => Fx4.pos;
Fx5.samples() => Fx5.pos;

//arrays
[84, 88, 91, 93, 91, 88, 86, 83] @=> int glassNotes[];

[1,0,0,0,1,0,0,0] @=> int fx_ptrn_1[];
[0,0,1,0,0,0,1,0] @=> int fx_ptrn_2[];
[1,0,1,0,1,0,1,0] @=> int fx_ptrn_3[];
[0,1,0,1,0,1,1,1] @=> int fx_ptrn_4[];

[1,0,0,0,1,0,0,0] @=> int glass_ptrn_1[];
[1,0,1,1,0,1,0,1] @=> int glass_ptrn_2[];
[1,0,0,0,0,0,1,0] @=> int glass_ptrn_3[];

0.045 => float glassVolume;

//glass
fun void glassSound(int note)
{
    Std.mtof(note) => glass.freq;
    Std.mtof(note) * 2.4 => glassHigh.freq;

    glassVolume => glass.gain;
    glassVolume * 0.3 => glassHigh.gain;
    0.04::second => now;

    glassVolume * 0.55 => glass.gain;
    glassVolume * 0.12 => glassHigh.gain;
    0.06::second => now;

    glassVolume * 0.2 => glass.gain;
    0 => glassHigh.gain;
    0.08::second => now;

    0 => glass.gain;
}

// chord
fun void playChord(int root, string quality)
{
    Std.mtof(root) => chord[0].freq;

    if(quality == "major")
    {
        Std.mtof(root + 4) => chord[1].freq;
    }
    else
    {
        Std.mtof(root + 3) => chord[1].freq;
    }

    Std.mtof(root + 7) => chord[2].freq;
}

// slow section
fun void sec1(int seq1[], int seq2[], int glassSeq[], float beatTime)
{
    for(0 => int i; i < seq1.cap(); i++)
    {
        if(seq1[i] == 1)
        {
            Math.random2(0, Fx2.samples() - 1) => Fx2.pos;
            Math.random2f(0.4, 1.0) => Fx2.rate;
        }

        if(seq2[i] == 1)
        {
            Math.random2(0, Fx3.samples() - 1) => Fx3.pos;
            Math.random2f(0.4, 1.0) => Fx3.rate;
        }

        if(glassSeq[i] == 1)
        {
            Math.random2(0, glassNotes.cap() - 1) => int n;
            glassSound(glassNotes[n]);
            (beatTime - 0.18)::second => now;
        }
        else
        {
            beatTime::second => now;
        }
    }
}

// fast section
fun void sec2(int seq1[], int seq2[], int glassSeq[], float beatTime)
{
    for(0 => int i; i < seq1.cap(); i++)
    {
        if(seq1[i] == 1)
        {
            0.13 => Fx4.gain;
            Math.random2(0, Fx4.samples() - 1) => Fx4.pos;
            Math.random2f(1.5, 3.0) => Fx4.rate;
        }

        if(seq2[i] == 1)
        {
            0.12 => Fx5.gain;
            Math.random2(0, Fx5.samples() - 1) => Fx5.pos;
            Math.random2f(1.5, 3.0) => Fx5.rate;
        }

        if(glassSeq[i] == 1)
        {
            Math.random2(0, glassNotes.cap() - 1) => int n;
            glassSound(glassNotes[n]);
            (beatTime - 0.18)::second => now;
        }
        else
        {
            beatTime::second => now;
        }
    }
}


//intro
Std.mtof(33) => s.freq;
0.008 => s.gain;

0 => Fx1.pos;
0 => Fx2.pos;
0.12 => Fx1.rate;
0.20 => Fx2.rate;
0.05 => Fx1.gain;
0.04 => Fx2.gain;
4::second => now;
Fx2.samples() => Fx2.pos;

// 1
<<< "PART 1 - QUIET" >>>;
0.012 => s.gain;
0.045 => Fx1.gain;
0.10 => Fx2.gain;
0.08 => Fx3.gain;
0.045 => glassVolume;

for(0 => int i; i < 6; i++)
{
    0.02 + i * 0.004 => master.gain;

    if(i == 0)
    {
        playChord(45, "minor");
        0 => Fx1.pos;
        Math.random2f(0.10, 0.20) => Fx1.rate;
    }
    if(i == 2)
    {
        playChord(41, "major");
    }
    if(i == 4)
    {
        playChord(45, "minor");
        0 => Fx1.pos;
        Math.random2f(0.10, 0.20) => Fx1.rate;
    }

    sec1(fx_ptrn_1, fx_ptrn_2, glass_ptrn_1, 0.60);
}

// short pause
0 => master.gain;
0 => s.gain;
Fx1.samples() => Fx1.pos;
Fx2.samples() => Fx2.pos;
Fx3.samples() => Fx3.pos;
1.5::second => now;

// 2
<<< "PART 2 - BUSY" >>>;

0.07 => master.gain;
0.020 => s.gain;
0.055 => Fx1.gain;
0.065 => glassVolume;

for(0 => int i; i < 3; i++)
{
    0 => Fx1.pos;
    Math.random2f(0.20, 0.35) => Fx1.rate;

    playChord(45, "minor");
    sec2(fx_ptrn_3, fx_ptrn_4, glass_ptrn_2, 0.32);
    sec2(fx_ptrn_3, fx_ptrn_4, glass_ptrn_2, 0.32);

    playChord(43, "major");
    sec2(fx_ptrn_3, fx_ptrn_4, glass_ptrn_2, 0.32);
    sec2(fx_ptrn_3, fx_ptrn_4, glass_ptrn_2, 0.32);
}

// short pause
0 => master.gain;
0 => s.gain;
Fx1.samples() => Fx1.pos;
Fx4.samples() => Fx4.pos;
Fx5.samples() => Fx5.pos;
1.5::second => now;

// 3 fade

for(0 => int i; i < 7; i++)
{
    0.065 - i * 0.008 => master.gain;
    0.016 - i * 0.002 => s.gain;
    0.055 - i * 0.007 => Fx1.gain;
    0.10 - i * 0.014 => Fx2.gain;
    0.08 - i * 0.011 => Fx3.gain;
    0.055 - i * 0.0066 => glassVolume;

    if(i == 0)
    {
        playChord(45, "minor");
        0 => Fx1.pos;
        Math.random2f(0.10, 0.20) => Fx1.rate;
    }
    if(i == 2)
    {
        playChord(41, "major");
    }
    if(i == 4)
    {
        playChord(45, "minor");
        0 => Fx1.pos;
        Math.random2f(0.10, 0.20) => Fx1.rate;
    }
    if(i == 6)
    {
        playChord(41, "major");
    }

    sec1(fx_ptrn_1, fx_ptrn_2, glass_ptrn_3, 0.68);
}

//fade
Fx2.samples() => Fx2.pos;
Fx3.samples() => Fx3.pos;

for(0 => int i; i < 25; i++)
{
    master.gain() * 0.86 => master.gain;
    s.gain() * 0.86 => s.gain;
    Fx1.gain() * 0.86 => Fx1.gain;
    0.12::second => now;
}

0 => master.gain;
0 => s.gain;
0 => Fx1.gain;
0 => glass.gain;
0 => glassHigh.gain;
