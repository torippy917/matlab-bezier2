function m = test(n)

if ischar(n)
    n=str2double(n);
end
m = magic(n)