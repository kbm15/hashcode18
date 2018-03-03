%% File A
load a_example.in
optimize(a_example, 'a')

%% File B
load b_should_be_easy.in
optimize(b_should_be_easy, 'b')

%% File C
load c_no_hurry.in
optimize(c_no_hurry, 'c', 275)

%% File D
load d_metropolis.in
load seedd.mat
for i = 1:4
    next = optimize(d_metropolis, 'd', seedd)
    seedd = [seedd next];
    save seedd
end

%% File E
load e_high_bonus.in
optimize(e_high_bonus, 'e', 1356)

%% Fun
load a_example.in
optimize(a_example, 'a')

load b_should_be_easy.in
optimize(b_should_be_easy, 'b')

load c_no_hurry.in
optimize(c_no_hurry, 'c')

load d_metropolis.in
optimize(d_metropolis, 'd')

load e_high_bonus.in
optimize(e_high_bonus, 'e')