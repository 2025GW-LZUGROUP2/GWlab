function[] = SurfacePlot(X,Y,Z,F)

colormap(jet);
surf(X,Y,Z,F);
shading interp;
axis equal;
colorbar;
line([-1.2;1.2],[0;0],[0;0],'Color',[1,0,0],'LineWidth',2); %X arm
line([0;0],[-1.2;1.2],[0;0],'Color',[0,0,1],'LineWidth',2); %Y arm
line([0;0],[0;0],[-1.2;1.2],'Color',[0,0,0],'LineWidth',2); %Z arm