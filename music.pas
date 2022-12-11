unit music;

interface

uses sdl, sdl_mixer;

const AUDIO_FREQUENCY: INTEGER = 22050;
    AUDIO_FORMAT: WORD = AUDIO_S16;
    AUDIO_CHANNELS: INTEGER = 2;
    AUDIO_CHUNKSIZE: INTEGER = 4096;

// Lance la musique de tetris
procedure play_music(var sound: pMIX_MUSIC);

// Stoppe la musique de tetris
procedure stop_music(var sound: pMIX_MUSIC);

implementation

// Lance la musique de tetris
procedure play_music(var sound: pMIX_MUSIC);
begin
    if MIX_OpenAudio(AUDIO_FREQUENCY, AUDIO_FORMAT, AUDIO_CHANNELS, AUDIO_CHUNKSIZE) <> 0 then
        Halt();
    sound := MIX_LOADMUS ('music.wav');
    MIX_VolumeMusic ( MIX_MAX_VOLUME );
    MIX_PlayMusic ( sound , -1);
end;

// Stoppe la musique de tetris
procedure stop_music(var sound: pMIX_MUSIC);
begin
    MIX_FREEMUSIC(sound);
    Mix_CloseAudio();
end;

end.
