function [U]=r_equelon(A)
%Esta funcion obtiene la matriz escalón reducida mediante
%eliminacion de GAUSS-JORDAN. 
%La variable de entrada debe ser una matriz de dimension mxn tal que n>m
%la variable de salida es matriz escalon-reducida correspondiente: U =
%[eye(n) X]. 
%Si consideramos la n primeras columnas de A como la matriz de
%un sistema de ecuaciones lineales de dimension nxn, y cada una de las
%columnas restantes como un posible vector de términos independientes,
%cada columna de la submatriz x de U, representa la solucion
%correspondiente.
% En particular, si introducimos una matriz de la forma A = [M eye(n)], la
% submatriz x de U es precisamente la inversa de M.

%Obtenemos el numero de filas de la matriz..
nf=size(A,1);
U=A;
%
%Primera parte: reduccion a una matriz triangular por eliminacion
%progresiva
for j=1:nf-1 %recorro todas la columnas menos la ultima
    
%%%%%%%%%%%pivoteo de filas%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %Buscamos el elemento mayor de la columna j de la diagonal para abajo
    maxcol=U(j,j);
    index=j;
    for l=j:nf
        if U(l,j)>maxcol
            maxcol=U(l,j);
            index=l;
        end
    end
    %si el mayor no era el elemento de la diagonal U(j,j), intecambiamos la
    %fila l con la fila j
    if index~=j
        aux=U(j,:);
        U(j,:)=U(l,:);
        U(l,:)=aux;
    end
%%%%%%%%fin del pivoteo de filas%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i=j+1:nf %Recorro las filas desde debajo de la diagonal hasta la 
        %ultima en matlab tengo la suerte de poder manejar cada fila de un 
        %solo golpe.
        U(i,:)=U(i,:)-U(j,:)*U(i,j)/U(j,j);
    end
end


%Segunda parte, obtencion de una matriz diagonal mediante eliminacion
%regresiva, Recorremos ahora las columnas en orden inverso empezando por el
%final... (Eliminacion de Gauss Jordan)

for j=nf:-1:2
    for i=j-1:-1:1 %Recorro las filas desde encima de la diagonal hasta la
        %segunda, 
        U(i,:)=U(i,:)-U(j,:)*U(i,j)/U(j,j);
    end
end

%Tercera parte, dividimos cada fila por el elemento de dicha fila que
%pertenece a la diagonal principal. 

for i=1:nf
    U(i,:) = U(i,:)/U(i,i);
    
end



