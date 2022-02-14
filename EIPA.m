clear all
clearvars
clearvars -GLOBAL
close all
format shorte

tiledlayout(3,3)

nx = 50;
ny = nx;
dx2 = 1;

G = sparse(nx*ny);

modes = zeros(nx,ny);

for i = 1:nx
    for j = 1:ny

        n = j + (i-1)*ny; % node mapping

        if (i == 1) || (i == nx) || (j == ny) || (j == 1) % BC set to 0
            
            % Bounds in G are set to 1
            G(n,n) = 1;
            
%         elseif (((i>10) && (i<20)) && ((j>10) && (j<20)))
%             
%             nxm = j + (i-2)*ny;
%             nxp = j + i*ny;
%             nym = (j-1) + (i-1)*ny;
%             nyp = (j+1) + (i-1)*ny;
%             
%             G(n,n) = -2;
%             G(n,nxm) = 1;
%             G(n,nxp) = 1;
%             G(n,nym) = 1;
%             G(n,nyp) = 1;
            
        else % middle node
            
            nxm = j + (i-2)*ny;
            nxp = j + i*ny;
            nym = (j-1) + (i-1)*ny;
            nyp = (j+1) + (i-1)*ny;
            
            % middle nodes in G, based on the sum of four neighbour cells
            G(n,n) = -4;
            G(n,nxm) = 1;
            G(n,nxp) = 1;
            G(n,nym) = 1;
            G(n,nyp) = 1;

        end

    end
end

% E = eigenvectors
% D = eigenvalues
[E,D] = eigs(G,9,'SM');

[Dsort, I] = sort(diag(D)); % pull diagonals and sort them
D = D(I,I);

for currMode = 1:9
    
    for i = 1:nx
        for j = 1:ny
            
            n = j + (i-1)*ny;

            modes(i,j) = E(n,currMode);

        end
    end
    
    nexttile
    surf(modes);
    
end

% Plot G using spy()
figure(2)
spy(G)

% Plot eigenvalues
figure(3)
plot(D)
title('Eigenvalues')
