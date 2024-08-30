class c_1_1;
    bit[0:0] rst_156m25 = 1'h0;

    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (/home/sf10286/UVM-Project/Advait_Madhekar/testcases/reset_seq.sv:7)
    {
       (rst_156m25 == 1'h1);
    }
endclass

program p_1_1;
    c_1_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "xzzz0x1zxz10z11zzz00xzzzz1z10zx0zzzxxxzxxzzzxxzzxzzzzzxzxzxzxxxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
