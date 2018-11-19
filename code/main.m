image = imread('../data/images/c1.jpg');
mask = imread('../data/images/c1_mask.pgm');

psi = 9;
window = 18;
alpha=255;

[rows,cols] = size(image);
confidence_mat = ones(rows,cols);

for i=1:rows
    for j=1:cols
        if mask(i,j) == 0
           confidence_mat(i,j) = 0;
        end
    end
end

while 1
    border_list = find_border(image,mask);
    if size(border_list) == [0,0]
       break
    end
    
    [rows,cols] = size(border_list);
    max_p_x = 0;
    max_p_y = 0;
    max_p = -1;
    G = gradient();
    
    for i = 1:rows
        x = border_list(i,1); 
        y = border_list(i,2);
        cp = confidence(psi,x,y,confidence_mat);
        dt = isophote(x,y,G,psi,mask);
        norm = norm_vec(border_list,[x,y]);
        dp = abs(dt'*norm)/alpha;
        prio = cp*dp;
        if prio > max_p
            max_p_x = x;
            max_p_y = y;
            max_p = prio;
        end
    end
    confidence_mat(max_x,max_y) = confidence(psi,max_x,max_y,confidence_mat);
    patch_fill(max_x,max_y,image,window,psi,confidence_mat);
end