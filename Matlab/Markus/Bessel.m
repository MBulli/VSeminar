[nu,z]=meshgrid(linspace(0,15,50),linspace(0,20,50));
myBessel=besselj(nu,z);
surf(nu,z,myBessel)
xlabel('\nu')
ylabel('I')
zlabel('J_\nu(z)')