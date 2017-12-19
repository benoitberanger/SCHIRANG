function GenerateRect( self )

self.baseRect  = [0 0 size(self.img,1) size(self.img,2)];
self.scaleRect = ScaleRect(self.baseRect, self.scale, self.scale);
self.scaleRect = CenterRectOnPoint(self.scaleRect, self.center(1), self.center(2));

end % function
