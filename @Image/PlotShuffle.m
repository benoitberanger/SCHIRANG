function PlotShuffle( self )

f = figure;
ax = axes(f);
% image(ax, self.img)
img = self.img;
img = reshape(img,[size(img,1)*size(img,2) size(img,3)]);
img = img(Shuffle(1:size(img,1)),:);
img = reshape(img,size(self.img));
image(ax, img)
colormap(ax, gray(256))
set(ax, 'XAxisLocation', 'top')
axis(ax, 'equal')

end % function
