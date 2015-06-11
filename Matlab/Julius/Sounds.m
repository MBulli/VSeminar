
%Sounds for Prinzip
maxTime = 2;
t = linspace(0,maxTime,44100);
fC = 1200;
y1 = sin(2*pi*fC*t);
sound(y1,44100);
filename = 'D:\Julius\Desktop\SoundBeispiele\prinzip_func1.wav';
audiowrite(filename,y1,44100);%Träger

t1 = linspace(0,maxTime,44100);
fM = 400;
I = 5;
y2 = I*sin(2*pi*fM*t);
sound(y2,44100);
filename = 'D:\Julius\Desktop\SoundBeispiele\prinzip_func2.wav';
audiowrite(filename,y2,44100);%Modulator

t2 = linspace(0,maxTime,44100);
y3 = sin(2*pi*fC*t2 + I*sin(2*pi*fM*t2));
sound(y3,44100);
filename = 'D:\Julius\Desktop\SoundBeispiele\prinzip_modwave.wav';
audiowrite(filename,y3,44100);


%Sounds for Beispiel 1
maxTime = 2;
t = linspace(0,maxTime,44100);
fC = 600;
y1 = sin(2*pi*fC*t);
sound(y1,44100);
filename = 'D:\Julius\Desktop\SoundBeispiele\beispiel1_func1.wav';
audiowrite(filename,y1,44100);%Träger

t1 = linspace(0,maxTime,44100);
fM = 600/8;
I = 5;
y2 = I*sin(2*pi*fM*t);
sound(y2,44100);
filename = 'D:\Julius\Desktop\SoundBeispiele\beispiel1_func2.wav';
audiowrite(filename,y2,44100);%Modulator

t2 = linspace(0,maxTime,44100);
y3 = sin(2*pi*fC*t2 + I*sin(2*pi*fM*t2));
sound(y3,44100);
filename = 'D:\Julius\Desktop\SoundBeispiele\beispiel1_modwave.wav';
audiowrite(filename,y3,44100);

%Sounds for Beispiel 2
maxTime = 2;
t = linspace(0,maxTime,44100);
fC = 300;
y1 = sin(2*pi*fC*t);
sound(y1,44100);
filename = 'D:\Julius\Desktop\SoundBeispiele\beispiel2_func1.wav';
audiowrite(filename,y1,44100);%Träger

t1 = linspace(0,maxTime,44100);
fM = 120;
I = 5;
y2 = I*sin(2*pi*fM*t);
sound(y2,44100);
filename = 'D:\Julius\Desktop\SoundBeispiele\beispiel2_func2.wav';
audiowrite(filename,y2,44100);%Modulator

t2 = linspace(0,maxTime,44100);
y3 = sin(2*pi*fC*t2 + I*sin(2*pi*fM*t2));
sound(y3,44100);
filename = 'D:\Julius\Desktop\SoundBeispiele\beispiel2_modwave.wav';
audiowrite(filename,y3,44100);                                                                                                                                                                                                                                                                                                                                                                                                                                                                  !!^!^^^^!^!!!!!!!!!!!!  


