/*
Emre Kirmizi

External modules to be implemented:
- Binary to 7 segment decoder (bin2ssd) //implemented


*/


module hockey(

    input clk,
    input rst,
    
    input BTN_A,
    input BTN_B,
    
    input [1:0] DIR_A,
    input [1:0] DIR_B,
    
    input [2:0] Y_in_A,
    input [2:0] Y_in_B,


    output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,  
    output reg [6:0] SSD2, //left
    output reg [6:0] SSD1, //mid
    output reg [6:0] SSD0  //right

	
    
    );
        

	reg [2:0] X_COORD;
	reg [2:0] Y_COORD;
    
    reg [3:0]  state; //state variable
    reg turn;
    reg [1:0] dir;
    reg [1:0] score_A;
    reg [1:0] score_B;
    reg doBlink;
    

    reg[8:0] timer_count;

    parameter ZERO = 7'b0000001;
    parameter ONE = 7'b1001111;
    parameter TWO = 7'b0010010;
    parameter THREE = 7'b0000110;
    parameter FOUR = 7'b1001100;
    parameter FIVE = 7'b0100100;
    parameter SIX = 7'b0100000;
    parameter SEVEN = 7'b0001111;


    parameter   IDLE = 4'b0000;
    parameter   DISP = 4'b0001;    
    parameter   HIT_A = 4'b0010;
    parameter   HIT_B = 4'b0011;
    parameter   SEND_A = 4'b0100;
    parameter   SEND_B = 4'b0101;
    parameter   RESP_A = 4'b0110;
    parameter   RESP_B = 4'b0111;
    parameter   GOAL_A = 4'b1000;
    parameter   GOAL_B = 4'b1001;
    parameter   _END = 4'b1010;
    
    parameter delay = 50; //set 200000000 for 2 second delay, in 10MHz clock

    always @ (*)   //for ssd's
    begin
        case (state)
            IDLE:
                begin
                    SSD0 = 7'b1100000;  //Says b
                    SSD1 = 7'b1111110;  //Says -
                    SSD2 = 7'b0001000; //Says A
                    SSD3 = 7'b1111111; //Says nothing
                    SSD4 = 7'b1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                end

            DISP:
                begin
                    SSD3 = 7'b1111111; //Says nothing
                    SSD4 = 7'b1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    SSD1 = 7'b1111110;  //Says -
                    if (score_A == 0)
                        SSD2 = ZERO;
                    else if (score_A == 1)
                        SSD2 = ONE;
                    else if (score_A == 2)
                        SSD2 = TWO;
                    else
                        SSD2 = THREE;

                    if (score_B == 0)
                        SSD0 = ZERO;
                    else if (score_B == 1)
                        SSD0 = ONE;
                    else if (score_B == 2)
                        SSD0 = TWO;
                    else
                        SSD0 = THREE;      
                end
            
            HIT_A:
                begin
                    SSD0 = 7'b1111111; //Says nothing
                    SSD1 = 7'b1111111; //Says nothing
                    SSD2 = 7'b1111111; //Says nothing
                    SSD3 = 7'b1111111; //Says nothing
                    // SSD4 = 1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    if (Y_in_A == 0)
                        SSD4 = ZERO;
                    else if (Y_in_A == 1)
                        SSD4 = ONE;
                    else if (Y_in_A == 2)
                        SSD4 = TWO;
                    else if (Y_in_A == 3)
                        SSD4 = THREE;
                    else if (Y_in_A == 4)
                        SSD4 = FOUR;
                    else 
                        SSD4 = 7'b1111110;
                end

                HIT_B:
                begin
                    SSD0 = 7'b1111111; //Says nothing
                    SSD1 = 7'b1111111; //Says nothing
                    SSD2 = 7'b1111111; //Says nothing
                    SSD3 = 7'b1111111; //Says nothing
                    // SSD4 = 1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    if (Y_in_B == 0)
                        SSD4 = ZERO;
                    else if (Y_in_B == 1)
                        SSD4 = ONE;
                    else if (Y_in_B == 2)
                        SSD4 = TWO;
                    else if (Y_in_B == 3)
                        SSD4 = THREE;
                    else if (Y_in_B == 4)
                        SSD4 = FOUR;
                    else 
                        SSD4 = 7'b1111110;
                end

                SEND_A:
                begin
                    SSD0 = 7'b1111111; //Says nothing
                    SSD1 = 7'b1111111; //Says nothing
                    SSD2 = 7'b1111111; //Says nothing
                    SSD3 = 7'b1111111; //Says nothing
                    SSD4 = 7'b1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    if (Y_COORD == 0)
                        SSD4 = ZERO;
                    else if (Y_COORD == 1)
                        SSD4 = ONE;
                    else if (Y_COORD == 2)
                        SSD4 = TWO;
                    else if (Y_COORD == 3)
                        SSD4 = THREE;
                    else if (Y_COORD == 4)
                        SSD4 = FOUR;
                    else
                        SSD4 = 7'b1111110;
                end

                SEND_B:
                begin
                    SSD0 = 7'b1111111; //Says nothing
                    SSD1 = 7'b1111111; //Says nothing
                    SSD2 = 7'b1111111; //Says nothing
                    SSD3 = 7'b1111111; //Says nothing
                    SSD4 = 7'b1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    if (Y_COORD == 0)
                        SSD4 = ZERO;
                    else if (Y_COORD == 1)
                        SSD4 = ONE;
                    else if (Y_COORD == 2)
                        SSD4 = TWO;
                    else if (Y_COORD == 3)
                        SSD4 = THREE;
                    else if (Y_COORD == 4)
                        SSD4 = FOUR;
                    else
                        SSD4 = 7'b1111110;
                end

                RESP_A:
                begin
                    SSD0 = 7'b1111111; //Says nothing
                    SSD1 = 7'b1111111; //Says nothing
                    SSD2 = 7'b1111111; //Says nothing
                    SSD3 = 7'b1111111; //Says nothing
                    SSD4 = 7'b1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    if (Y_COORD == 0)
                        SSD4 = ZERO;
                    else if (Y_COORD == 1)
                        SSD4 = ONE;
                    else if (Y_COORD == 2)
                        SSD4 = TWO;
                    else if (Y_COORD == 3)
                        SSD4 = THREE;
                    else if (Y_COORD == 4)
                        SSD4 = FOUR;
                    else
                        SSD4 = 7'b1111110;
                end

                RESP_B:
                begin
                    SSD0 = 7'b1111111; //Says nothing
                    SSD1 = 7'b1111111; //Says nothing
                    SSD2 = 7'b1111111; //Says nothing
                    SSD3 = 7'b1111111; //Says nothing
                    SSD4 = 7'b1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    if (Y_COORD == 0)
                        SSD4 = ZERO;
                    else if (Y_COORD == 1)
                        SSD4 = ONE;
                    else if (Y_COORD == 2)
                        SSD4 = TWO;
                    else if (Y_COORD == 3)
                        SSD4 = THREE;
                    else if (Y_COORD == 4)
                        SSD4 = FOUR;
                    else
                        SSD4 = 7'b1111110;
                end

                GOAL_A:
                //print scores
                begin
                    SSD3 = 7'b1111111; //Says nothing
                    SSD4 = 7'b1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    SSD1 = 7'b1111110;  //Says -
                    if (score_A == 0)
                        SSD2 = ZERO;
                    else if (score_A == 1)
                        SSD2 = ONE;
                    else if (score_A == 2)
                        SSD2 = TWO;
                    else
                        SSD2 = THREE;

                    if (score_B == 0)
                        SSD0 = ZERO;
                    else if (score_B == 1)
                        SSD0 = ONE;
                    else if (score_B == 2)
                        SSD0 = TWO;
                    else
                        SSD0 = THREE;      
   
                end

                GOAL_B:
                //print scores

                begin
                    SSD3 = 7'b1111111; //Says nothing
                    SSD4 = 7'b1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    SSD1 = 7'b1111110;  //Says -
                    if (score_A == 0)
                        SSD2 = ZERO;
                    else if (score_A == 1)
                        SSD2 = ONE;
                    else if (score_A == 2)
                        SSD2 = TWO;
                    else
                        SSD2 = THREE;
                    

                    if (score_B == 0)
                        SSD0 = ZERO;
                    else if (score_B == 1)
                        SSD0 = ONE;
                    else if (score_B == 2)
                        SSD0 = TWO;
                    else
                        SSD0 = THREE;      
     
   
                end

                _END:
                //SSD4 print winner (A or b)
                //SSD2-0 prints score
                begin
                    SSD1 = 7'b1111110;
                    SSD3 = 7'b1111111; //Says nothing
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                    if (score_A == 0)
                        SSD2 = ZERO;
                    else if (score_A == 1)
                        SSD2 = ONE;
                    else if (score_A == 2)
                        SSD2 = TWO;
                    else
                        SSD2 = THREE;

                    if (score_B == 0)
                        SSD0 = ZERO;
                    else if (score_B == 1)
                        SSD0 = ONE;
                    else if (score_B == 2)
                        SSD0 = TWO;
                    else
                        SSD0 = THREE;   

                    if (score_A > score_B)
                        SSD4 = 7'b0001000;
                    else
                        SSD4 = 7'b1100000;
                          
                end
                default:
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD3 = 7'b1111111; //Says nothing
                    SSD4 = 7'b1111111;
                    SSD5 = 7'b1111111; //Says nothing
                    SSD6 = 7'b1111111; //Says nothing
                    SSD7 = 7'b1111111; //Says nothing
                end
            endcase
        end

        always @ (*) //forleds
        begin
            case(state)
                IDLE:
                begin
                    LEDA = 1'b1;
                    LEDB = 1'b1;
                    LEDX = 5'b00000;
                end

                DISP:
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                    LEDX = 5'b11111;
                end

                HIT_A:
                begin
                    LEDA = 1'b1;
                    LEDB = 1'b0;
                    LEDX = 5'b00000;
                end

                HIT_B:
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b1;
                    LEDX = 5'b00000;
                end

                SEND_A:
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                    if (X_COORD == 0)
                        LEDX = 5'b10000;
                    else if (X_COORD == 1)  
                        LEDX = 5'b01000;
                    else if (X_COORD == 2)
                        LEDX = 5'b00100;
                    else if (X_COORD == 3)
                        LEDX = 5'b00010;
                    else
                        LEDX = 5'b00001;
                     
                end

                SEND_B:
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                    if (X_COORD == 0)
                        LEDX = 5'b10000;
                    else if (X_COORD == 1)  
                        LEDX = 5'b01000;
                    else if (X_COORD == 2)
                        LEDX = 5'b00100;
                    else if (X_COORD == 3)
                        LEDX = 5'b00010;
                    else
                        LEDX = 5'b00001;
                end

                RESP_A:
                begin
                    LEDA = 1'b1;
                    LEDB = 1'b0;
                    LEDX = 5'b10000;
                end

                RESP_B:
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b1;
                    LEDX = 5'b00001;
                end

                GOAL_A:
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                    LEDX = 5'b11111;
                end

                GOAL_B:
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                    LEDX = 5'b11111;
                end

                _END:
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                    if (score_A > score_B)
                        LEDA = 1'b1;
                    else
                        LEDB = 1'b1;

                    if (doBlink == 0)
                        LEDX = 5'b01010;
                    else
                        LEDX = 5'b10101;
                end
                
                default:
                begin
                    LEDA = 1'b0;
                    LEDB = 1'b0;
                    LEDX = 5'b00000;
                end
                    
            endcase
        end

        
    
    
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            // LEDA <= 1'b0;
            // LEDB <= 1'b0;
            // LEDX <= 5'b00000;
            // SSD2 <= 7'b1111111;
            // SSD1 <= 7'b1111111;
            // SSD0 <= 7'b1111111;
            score_A <= 2'b00;
            score_B <= 2'b00;
            timer_count <= 0;
            X_COORD <= 3'b000;
            Y_COORD <= 3'b000;
            state <= IDLE;
        end
        
        else
            case(state)
                IDLE:
                    begin
                        // LEDA <= 1'b0;
                        // LEDB <= 1'b0;
                        // LEDX <= 5'b00000;
                        if(BTN_A)
                            begin
                                turn <= 1'b1;
                                state <= DISP;

                            end
                        else if(BTN_B)
                            begin
                                turn <= 1'b0;
                                state <= DISP;

                            end
                        else
                            begin
                                turn <= turn;
                                state <= IDLE;
                            end
                    end
                DISP:
                    begin
                        //set ssd2 to A's score
                        //set ssd0 to B's score
                        //set ssd1 to -

                        // SSD2 <= bin2ssd(score_A);
                        // SSD0 <= bin2ssd(score_B);
                        // SSD1 <= 7'b1111110;


                        if (timer_count < delay - 1)
                            timer_count <= timer_count + 1;
                        else
                            begin
                                timer_count <= 0;
                                if(turn) //if it is A's turn
                                        state <= HIT_A;
                                else //if it is B's turn
                                        state <= HIT_B;
                            end
                    end
                HIT_A:
                    begin
                        // LEDA <= 1'b1;
                        // LEDB <= 1'b0;
                        if (BTN_A && Y_in_A < 5) 
                            begin
                                X_COORD <= 3'b000;
                                Y_COORD <= Y_in_A; 
                                dir <= DIR_A;
                                state <= SEND_B;
                            end
                        else
                            state <= HIT_A;
                    end
                    
                HIT_B:
                    begin
                        // LEDA <= 1'b0;
                        // LEDB <= 1'b1;
                        if (BTN_B && Y_in_B < 5) 
                            begin
                                X_COORD <= 3'b100;
                                Y_COORD <= Y_in_B; 
                                dir <= DIR_B;
                                state <= SEND_A;
                            end
                        else
                            state <= HIT_B;
                    end
                SEND_A:
                    begin
                        if (timer_count < delay - 1)
                            timer_count <= timer_count + 1;
                        else
                            begin
                                timer_count <= 0;
                                case (dir)
                                    2'b10:
                                        begin
                                            if (Y_COORD == 0)
                                                begin
                                                    dir <= 2'b01;
                                                    Y_COORD <= Y_COORD + 1;
                                                    if (X_COORD > 1)
                                                        begin
                                                            X_COORD <= X_COORD - 1;
                                                            state <= SEND_A;
                                                        end
                                                    else
                                                        begin
                                                            X_COORD <= 0;
                                                            state <= RESP_A;
                                                        end
                                                end
                                            else
                                                Y_COORD <= Y_COORD - 1;
                                                if (X_COORD > 1)
                                                    begin
                                                        X_COORD <= X_COORD - 1;
                                                        state <= SEND_A;
                                                    end
                                                else
                                                    begin
                                                        X_COORD <= 0;
                                                        state <= RESP_A;
                                                    end
                                        end

                                    2'b01:
                                        begin
                                            if (Y_COORD == 4)
                                                begin
                                                    dir <= 2'b10;
                                                    Y_COORD <= Y_COORD - 1;
                                                    if (X_COORD > 1)
                                                        begin
                                                            X_COORD <= X_COORD - 1;
                                                            state <= SEND_A;
                                                        end
                                                    else
                                                        begin
                                                            X_COORD <= 0;
                                                            state <= RESP_A;
                                                        end
                                                end
                                            else
                                                Y_COORD <= Y_COORD + 1;
                                                if (X_COORD > 1)
                                                    begin
                                                        X_COORD <= X_COORD - 1;
                                                        state <= SEND_A;
                                                    end 
                                                else
                                                    begin
                                                        X_COORD <= 0;
                                                        state <= RESP_A;
                                                    end
                                        end
                                    2'b00: 
                                        begin
                                            if (X_COORD > 1)
                                                begin
                                                    X_COORD <= X_COORD - 1;
                                                    state <= SEND_A;
                                                end
                                            else
                                                begin
                                                    X_COORD <= 0;
                                                    state <= RESP_A;
                                                end
                                        end
                                    default: 
                                        begin
                                            
                                        end
                                endcase
                            end
                    end
                    

                SEND_B:
                    begin
                        if (timer_count < delay - 1)
                            timer_count <= timer_count + 1;
                        else
                            begin
                                timer_count <= 0;
                                case (dir)
                                    2'b10:
                                        begin
                                            if (Y_COORD == 0)
                                                begin
                                                    dir <= 2'b01;
                                                    Y_COORD <= Y_COORD + 1;
                                                    if (X_COORD < 3)
                                                        begin
                                                            X_COORD <= X_COORD + 1;
                                                            state <= SEND_B;
                                                        end
                                                    else
                                                        begin
                                                            X_COORD <= 4;
                                                            state <= RESP_B;
                                                        end
                                                end
                                            else
                                                begin
                                                Y_COORD <= Y_COORD - 1;
                                                if (X_COORD < 3)
                                                    begin
                                                        X_COORD <= X_COORD + 1;
                                                        state <= SEND_B;
                                                    end
                                                else
                                                    begin
                                                        X_COORD <= 4;
                                                        state <= RESP_B;
                                                    end
                                                end
                                        end
                                    2'b01:
                                        begin
                                            if (Y_COORD == 4)
                                                begin
                                                    dir <= 2'b10;
                                                    Y_COORD <= Y_COORD - 1;
                                                    if (X_COORD < 3)
                                                        begin
                                                            X_COORD <= X_COORD + 1;
                                                            state <= SEND_B;
                                                        end
                                                    else
                                                        begin
                                                            X_COORD <= 4;
                                                            state <= RESP_B;
                                                        end
                                                end
                                            else
                                                Y_COORD <= Y_COORD + 1;
                                                if (X_COORD < 3)
                                                    begin
                                                        X_COORD <= X_COORD + 1;
                                                        state <= SEND_B;
                                                    end
                                                else
                                                    begin
                                                        X_COORD <= 4;
                                                        state <= RESP_B;
                                                    end
                                        end
                                    2'b00:
                                        begin
                                            if (X_COORD < 3)
                                                begin
                                                    X_COORD <= X_COORD + 1;
                                                    state <= SEND_B;
                                                end
                                            else
                                                begin
                                                    X_COORD <= 4;
                                                    state <= RESP_B;
                                                end
                                        end
                                    default: 
                                    begin
                                        state <= SEND_B;
                                    end
                                endcase
                                        
                                                        
                            end
                        end
                RESP_A:
                    begin
                        if (timer_count < delay - 1)
                            begin
                                if (BTN_A && (Y_COORD == Y_in_A))
                                    begin
                                        X_COORD <= 1;
                                        timer_count <= 0;
                                        case (DIR_B)
                                                2'b00:
                                                    begin
                                                        dir <= DIR_B;
                                                        state <= SEND_B;
                                                    end
                                                2'b01:  
                                                    begin
                                                        if (Y_COORD == 4)
                                                            begin
                                                                dir <= 2'b10;
                                                                Y_COORD <= Y_COORD - 1;
                                                                state <= SEND_B;
                                                            end
                                                        else
                                                            begin
                                                                dir <= DIR_B;
                                                                Y_COORD <= Y_COORD + 1;
                                                                state <= SEND_B;                                                    
                                                            end
                                                    end
                                                2'b10:
                                                    begin
                                                        if (Y_COORD == 0)
                                                            begin
                                                                dir <= 2'b01;
                                                                Y_COORD <= Y_COORD + 1;
                                                                state <= SEND_B;
                                                            end
                                                        else
                                                            begin
                                                                dir <= DIR_B;
                                                                Y_COORD <= Y_COORD - 1;
                                                                state <= SEND_B;
                                                            end
                                                    end
                                               default: 
                                                    begin
                                                    end
                                            
                                        endcase
                                    end
                                else
                                    begin
                                        timer_count <= timer_count + 1;
                                        state <= RESP_A;
                                    end

                            end
                        else
                            begin
                                timer_count <= 0;
                                score_B <= score_B + 1;
                                state <= GOAL_B;
                            end
                    end
                RESP_B:
                    begin
                        if (timer_count < delay - 1)
                            begin
                                if (BTN_B && (Y_COORD == Y_in_B))
                                    begin
                                        X_COORD <= 3;
                                        timer_count <= 0;
                                        case(DIR_A)
                                            2'b00:
                                                begin
                                                    dir <= DIR_A;
                                                    state <= SEND_A;
                                                end
                                            2'b01:
                                                begin
                                                    if (Y_COORD == 4)
                                                        begin
                                                            dir <= 2'b10;
                                                            Y_COORD <= Y_COORD - 1;
                                                            state <= SEND_A;
                                                        end
                                                    else
                                                        begin
                                                            dir <= DIR_A;
                                                            Y_COORD <= Y_COORD + 1;
                                                            state <= SEND_A;
                                                        end
                                                end
                                            2'b10:
                                                begin
                                                    if (Y_COORD == 0)
                                                        begin
                                                            dir <= 2'b01;
                                                            Y_COORD <= Y_COORD + 1;
                                                            state <= SEND_A;
                                                        end
                                                    else
                                                        begin
                                                            dir <= DIR_A;
                                                            Y_COORD <= Y_COORD - 1;
                                                            state <= SEND_A;
                                                        end
                                                end
                                            default:
                                                begin
                                                end
                                        endcase
                                    end
                                else
                                    begin
                                        timer_count <= timer_count + 1;
                                        state <= RESP_B;
                                    end
                            end
                        else
                            begin
                                timer_count <= 0;
                                score_A <= score_A + 1;
                                state <= GOAL_A;
                            end
                    end
                GOAL_B:
                    begin
                        if (timer_count < delay - 1)
                            timer_count <= timer_count + 1;
                        else
                            begin
                                timer_count <= 0;
                                if (score_B == 3)
                                    begin
                                        turn <= 1'b1;
                                        state <= _END;
                                    end
                                else
                                    state <= HIT_A;
                            end
                    end
                GOAL_A:
                    begin
                        if (timer_count < delay - 1)
                            timer_count <= timer_count + 1;
                        else
                            begin
                                timer_count <= 0;
                                if (score_A == 3)
                                    begin
                                        turn <= 1'b0;
                                        state <= _END;
                                    end
                                else
                                    state <= HIT_B;
                            end
                    end
                _END:
                begin
                if (timer_count == 5)
                 begin
                    timer_count <= 0;
                    doBlink <= ~doBlink;
                 end
                else
                    timer_count <= timer_count + 1;
                    
                state <= _END;
                end

            endcase

            
	end
    
    
endmodule
