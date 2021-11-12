clear;
image_input = rgb2gray(imread('2.jpg'));
image_noisy = imnoise(image_input,'salt & pepper',0.2);
window_size=21;
padding_size = floor(window_size/2);
[row col]=size(image_noisy);
image_padded = padarray(image_noisy,[padding_size,padding_size],'symmetric');
image_output = image_noisy;
count=0;
subplot(1,2,1),imshow(image_noisy);
for i=padding_size+1:row+10
    for j=padding_size+1:col+10
        window_curr = image_padded(i-padding_size:i+padding_size,j-padding_size:j+padding_size);
        window_sort = sort(window_curr(:));
        med =window_sort(round((window_size*window_size)/2));
        x = window_size * window_size;
        vd = zeros(x-1,1);
        for k=1:x-1
            vd(k)=window_sort(k+1)-window_sort(k);
        end
        ind = find(window_sort==med);
        lower = vd(1:ind(1));
        [lower_max, ind_lowerMax] = max(lower);
        upper = vd(ind(1)+1:size(vd));
        [upper_max, ind_upperMax]=max(upper);
        ind_upperMax = ind_upperMax+ind(1);
        b1 = window_sort(ind_lowerMax);
        b2 = window_sort(ind_upperMax);
        count= 0;
        for m=ind_lowerMax+1:ind_upperMax
            if(image_padded(i,j) == window_sort(m))
                count = count+1;
                break;
            end
        end
        if(count>0)
            image_output(i-padding_size,j-padding_size) = image_padded(i,j);
            continue;
        else
            window_curr_3 = image_padded(i-1:i+1,j-1:j+1);
            window_sort_3 = sort(window_curr_3(:));
            med_3 =window_sort_3(round((3*3)/2));
            vd_3 = zeros(9,1);
            for k=1:8
                vd_3(k)=window_sort_3(k+1)-window_sort_3(k);
            end
             ind_3 = find(window_sort_3==med_3);
             lower_3 = vd_3(1:ind_3(1));
             [lower_max_3, ind_lowerMax_3] = max(lower_3);
             upper_3 = vd_3(ind_3(1)+1:size(vd_3));
             [upper_max_3, ind_upperMax_3]=max(upper_3);
             ind_upperMax_3 = ind_upperMax_3+ind_3(1);
             b1_3 = window_sort_3(ind_lowerMax_3);
             b2_3= window_sort_3(ind_upperMax_3);
             count_3= 0;
             for m=ind_lowerMax_3+1:ind_upperMax_3
                 if(image_padded(i,j) == window_sort_3(m))
                    count_3 = count_3+1; 
                 end
             end
             if(count_3>0)
                image_output(i-padding_size,j-padding_size) = image_padded(i,j);
                continue;
             else
                     patch = image_padded(i-1:i+1 ,j-1:j+1);
                     patch_sorted=sort(patch(:));
                     image_output(i-padding_size, j-padding_size)=patch_sorted(round((3*3)/2));
             end
        end
    end
end
peaksnr = psnr(image_output,image_input);
subplot(1,2,2),imshow(image_output);