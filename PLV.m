function [PLV_matrix] = PLV (start, finish, eeg,name) 

%inputs
%start: index of first epoch to consider
%end: index of last epoch to consider
%eeg: eeg matrix of channels x samples x epochs (already in phase form)
%name: name of .mat of speech structure

%output: plv matrix of channels x samples

%1. load speech signal 
%each language structure has 20 signals with different lengths 
load(name);
speech_signal=Phases;

%2. Createempty 2D matrix with epochs x samples 
%I put 3500 as an exageration so as to not cut any signal
PLV_matrix        = nan(20,3500); 

signalIDX=1;

%3. Go epoch by epoch
for epochIDX=start:finish % start undefined?
    
    
    speech=speech_signal{signalIDX}; %access specific speech signal 
    len = length(speech); %look for length of speech signal
    speech_all = repmat(speech,[106,1]); %repeat rows of speech signal so we have same dimensions as eeg
    speech_all = unwrap(speech_all); %unwrap angles of speech signal

    
    eeg_signal=eeg(:,:,epochIDX); %access specific epoch of eeg
    eeg_signal=eeg_signal(:,1:len); %cut epoch so that it has same length as speech
    
    dif_ph = (speech_all-eeg_signal); % calculate different between speech & EEG angles 
    expon = exp(1i*dif_ph); % exponentalize the difference
    
    PLV=  abs(mean(expon));
   
    PLV_matrix(signalIDX,1:len)=PLV;
    
    signalIDX=signalIDX+1;

end

end 