function [ texPtr ] = MakeTexture( self )

assert(~isempty(self.wPtr), 'use LinkToWindowPtr first')

texPtr = Screen('MakeTexture', self.wPtr, cat(3,self.X,self.alpha));

self.texPtr = texPtr;

end % function