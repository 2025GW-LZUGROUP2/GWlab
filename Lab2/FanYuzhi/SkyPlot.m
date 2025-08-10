function [] = SkyPlot(thetaVec,phiVec,F)
%Plot a function of sky angles on the unit sphere
%SKYPLOT(A,D,F)
%A and D are the vector of azimuthal and polar angle values respectively. F
%is the handle to the function of A and D that is to be plotted on the
%sphere. The polar angle range is 0 (z-axis) to Pi (negative z-axis). The
%angles are assumed to be in radian.
%
%Example:
% The function to be plotted is named 'fp' and accepts inputs 'theta' and
% 'phi'. Then,do:
% >> fhandle = @(x,y) fp(x,y)
% >> skyplot(0:0.1:(2*pi),0:0.1:pi, fhandle);

%Soumya D. Mohanty, June 2018

%Generate the X, Y, Z meshes corresponding to the azimuthal and polar
%angles
[phi, theta] = meshgrid(phiVec, thetaVec);
X = sin(theta).*cos(phi);
Y = sin(theta).*sin(phi);
Z = cos(theta);

%Generate function values
Fplot = zeros(length(thetaVec),length(phiVec));
for lp1 = 1:length(thetaVec)
    for lp2 = 1:length(phiVec)
        Fplot(lp1,lp2) = F(thetaVec(lp1),phiVec(lp2));
    end
end

%Plot
%figure;
colormap(jet);
surf(X,Y,Z,abs(Fplot));
shading interp; %确保表面图的颜色在网格点之间平滑过渡

axis equal;
colorbar;

%Add detector arms
line([-1.2;1.2],[0;0],[0;0],'Color',[1,0,0],'LineWidth',2); %X arm
line([0;0],[-1.2;1.2],[0;0],'Color',[0,0,1],'LineWidth',2); %Y arm
line([0;0],[0;0],[-1.2;1.2],'Color',[0,0,0],'LineWidth',2); %Z arm
