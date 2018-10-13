function hist = colorhist(image,n1,n2,n3)
R=histcounts(image(:,:,1),n1);
G=histcounts(image(:,:,2),n2);
B=histcounts(image(:,:,3),n3);

hist=R+G+B;
end