function Plot( self )

f = figure;
ax = axes(f);
image(ax, self.img)
colormap(ax, gray(256))
set(ax, 'XAxisLocation', 'top')
axis(ax, 'equal')

end % function
