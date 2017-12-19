classdef Image < baseObject
    %IMAGE Class to prepare and draw image in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        path      = char       % path of the image
        scale     = zeros(0,0) % scaling factor of the image
        center    = zeros(0,2) % [ CenterX CenterY ] of the cross, in pixels, PTB coordinates
        
        % Internal variables
        
        img       = zeros(0,0,3,'uint8') % iamge
        map       = zeros(0,0,3,'uint8') % color map
        alpha     = zeros(0,0,1,'uint8') % transparency
        
        baseRect  = zeros(0,4) % [x1 y1 x2 y2] pixels, PTB coordinates
        scaleRect = zeros(0,4) % [x1 y1 x2 y2] pixels, PTB coordinates
        
        texPtr    = zeros(0,0) % pointer to the texure in PTB
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        function self = Image( path, center, scale )
            % self = Image( path = '../img/[subjectID]/test.png', center = [ CenterX CenterY ] (pixels), scale = 1  )
            
            % ================ Check input argument =======================
            
            % Arguments ?
            if nargin > 0
                
                % --- path ----
                assert( ischar(path) && isvector(path) && ~isempty(path) , ...
                    'path = path of the image' )
                
                % --- center ----
                assert( isvector(center) && isnumeric(center) && all( center>0 ) && all(center == round(center)) , ...
                    'center = [ CenterX CenterY ] of the cross, in pixels' )
                
                % --- scale ----
                assert( isscalar(scale) && isnumeric(scale) && scale>0 , ...
                    'width = scaling factor of the image' )
                
                self.path   = path;
                self.center = center;
                self.scale  = scale;
                
                % ================== Callback =============================
                
                self.Load
                self.GenerateRect
                
            else
                % Create empty instance
            end
            
        end
        
        
    end % methods
    
    
end % class
