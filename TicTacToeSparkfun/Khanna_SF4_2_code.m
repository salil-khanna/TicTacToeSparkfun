classdef Khanna_SF4_2_code < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        Image                         matlab.ui.control.Image
        Label                         matlab.ui.control.Label
        Label_2                       matlab.ui.control.Label
        Label_3                       matlab.ui.control.Label
        ALabel                        matlab.ui.control.Label
        BLabel                        matlab.ui.control.Label
        CLabel                        matlab.ui.control.Label
        PlayerAHeadsorTailsEditFieldLabel  matlab.ui.control.Label
        PlayerAHeadsorTailsEditField  matlab.ui.control.EditField
        STARTGAMEButton               matlab.ui.control.Button
        TicTacToeLabel                matlab.ui.control.Label
        LandedonLabel                 matlab.ui.control.Label
        XsandRedareLabel              matlab.ui.control.Label
        OsandBlueareLabel             matlab.ui.control.Label
        ThecorrespondinglightLabel    matlab.ui.control.Label
        onthebreadboardshowsLabel     matlab.ui.control.Label
        whosturnitisLabel             matlab.ui.control.Label
        GamehasbeenLabel              matlab.ui.control.Label
        WinnerLabel                   matlab.ui.control.Label
        PressbuttononbreadboardtoconfirmLabel  matlab.ui.control.Label
        WhichRowEditFieldLabel        matlab.ui.control.Label
        WhichRowEditField             matlab.ui.control.NumericEditField
        WhichColumnEditFieldLabel     matlab.ui.control.Label
        WhichColumnEditField          matlab.ui.control.EditField
        A1Label                       matlab.ui.control.Label
        B1Label                       matlab.ui.control.Label
        C1Label                       matlab.ui.control.Label
        C2Label                       matlab.ui.control.Label
        B2Label                       matlab.ui.control.Label
        A2Label                       matlab.ui.control.Label
        A3Label                       matlab.ui.control.Label
        B3Label                       matlab.ui.control.Label
        C3Label                       matlab.ui.control.Label
        InvalidLabel                  matlab.ui.control.Label
    end

    
    properties (Access = private)
        aBoard % creates an empty object that the arduino properties will be stored into
    end
    
    methods (Access = private)
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.aBoard=arduino('COM4', 'uno'); %connects the arduino to MatLab
        end

        % Button pushed function: STARTGAMEButton
        function STARTGAMEButtonPushed(app, event)
            %defaults everything to simulate a new game whenever the start button
            %is pushed
            app.A1Label.Text = " ";
            app.B1Label.Text = " ";
            app.C1Label.Text = " ";
            app.A2Label.Text = " ";
            app.B2Label.Text = " ";
            app.C2Label.Text = " ";
            app.A3Label.Text = " ";
            app.B3Label.Text = " ";
            app.C3Label.Text = " ";
            app.WinnerLabel.Text = " ";
            app.InvalidLabel.Text = "Invalid?: ";

            
            %creates a variable for the userinput heads or tails
            flip = app.PlayerAHeadsorTailsEditField.Value;
            %sets a current variable for x(the variable used as the player choice)
            x=2;
    
            %code simulates a coin flip by having a 50/50 chance of being 0 or 1
            %(heads or tails) and saves that to a variable to later be compared 
            %with the player choice
            y=randi([0,1]);
    
            %this if/elseif statement converts playera's choice into a variable to
            %be compared with y (the coin flip)
            if (flip=="Heads" || flip == "heads")
                x=0;
            elseif (flip =="Tails" || flip == "tails")
                x=1;
            end
            
            %creates a variable for if player a or player b goes first, 0 means they
            %currently go second
            playerafirst=0;
            playerbfirst=0;
            
            %if the coin flip landed on heads and player a guessed correctly, player a is assigned to
            %going first (assigning the variable to 1 means they go first), while
            %player b remains at going second
            if x==y&&y==0
                app.LandedonLabel.Text = ("Landed on heads");
                app.XsandRedareLabel.Text = ("Xs and Red are Player A");
                app.OsandBlueareLabel.Text = ("Os and Blue are Player B");
                playerafirst=1;
     
            %if the coin flip landed on tails and player a guessed correctly, player a is assigned to
            %going first, while player b remains at going second    
            elseif x==y&&y==1
                app.LandedonLabel.Text = ("Landed on tails");
                app.XsandRedareLabel.Text = ("Xs and Red are Player A");
                app.OsandBlueareLabel.Text = ("Os and Blue are Player B");
                playerafirst=1;
    
            %if the coin flip landed on heads and player a did not guess correctly, player b is assigned to
            %going first, while player a remains at going second    
            elseif x~=y&&y==0
                app.LandedonLabel.Text = ("Landed on heads");
                app.XsandRedareLabel.Text = ("Xs and Red are Player B");
                app.OsandBlueareLabel.Text = ("Os and Blue are Player A");
                playerbfirst=1;
    
            %if the coin flip landed on tails and player a did not guess correctly, playerb is assigned to
            %going first, while player a remains at going second
            elseif x~=y&&y==1
                app.LandedonLabel.Text = ("Landed on tails");
                app.XsandRedareLabel.Text = ("Xs and Red are Player B");
                app.OsandBlueareLabel.Text = ("Os and Blue are Player A");
                playerbfirst = 1;        
            end
            
            %creates an array of zeros to store the Xs and Os to check if
            %the game has been won or if a spot has already been taken
            TTT = zeros(3,3);
            %sets default for win variable and turns starting at 1
            win= 0;
            turns = 1;
            %creates a while loop so that if the game has not been won it
            %continues as well as a while loop for total amount of turns
            while win ~= 1
                while turns <= 9
                    %creates a variable determining the remainder of the 
                    %current amount of turns, helping determine whos turn it is 
                    r =rem(turns,2);
                    % if player a is the one to go first and the remainder is odd,
                    % all the lines under the if statement are run through
                    if r == 1 && playerafirst == 1
                        %sets a variable named valid to false for a while loop
                        valid = false;
                        while valid == false
                        %turns off the blue light and turns on the red
                        %light to indicate it is Xs turn and variables for the input
                        %of row and column are created
                            app.aBoard.writeDigitalPin('D12',0);
                            app.aBoard.writeDigitalPin('D13',1);
                            row = app.WhichRowEditField.Value;
                            col = app.WhichColumnEditField.Value;
                            %converts the user's input of string into a
                            %number to make it easy for the matrix
                            if (col== "A")
                                acol = 1;
                            elseif (col == "B")
                                acol = 2;
                            elseif (col == "C")    
                                acol = 3;
                            end
                            
                            %a function checking if the spot inserted by
                            %the user was valid
                            if (row>3||row<1||acol>3||acol<1||TTT(row,acol)==1||TTT(row,acol)==2)
                                check = 1;
                            else
                                check = 0;
                            end
                               %creates a pause for the user to make sure they choose that location,
                               %and once the button the button is pressed, it breaks out of the loop, proceeding with the code 
                               while (readDigitalPin(app.aBoard, 'D6') == 1)
                                   if (readDigitalPin(app.aBoard, 'D6') == 0)
                                       break;
                                   end
                               end
                            
                            % if the spot by the user was not valid, it
                            % displays that they must try again, and
                            % continues the loop
                            if (check == 1)
                                app.InvalidLabel.Text = "Invalid?: Yes, try again";
                                valid = false;
                            %else, it shows that the spot was not invalid, sets the spot on the matrix to 1, and it plots the X 
                            %according to whatever spot the user chose and sets valid as true to break out of the player loop   
                            else
                                app.InvalidLabel.Text = "Invalid?: No, next turn";
                                TTT(row,acol)=1;
                                if (row == 1 && acol == 1)
                                    app.A1Label.Text = "X";
                                elseif (row == 1 && acol == 2)
                                    app.B1Label.Text = "X";
                                elseif (row == 1 && acol == 3)
                                    app.C1Label.Text = "X";
                                elseif (row == 2 && acol == 1)
                                    app.A2Label.Text = "X";
                                elseif (row == 2 && acol == 2)
                                    app.B2Label.Text = "X";
                                elseif (row == 2 && acol == 3)
                                    app.C2Label.Text = "X";
                                elseif (row == 3 && acol == 1)
                                    app.A3Label.Text = "X";     
                                elseif (row == 3 && acol == 2)
                                    app.B3Label.Text = "X";    
                                elseif (row == 3 && acol == 3)
                                    app.C3Label.Text = "X";    
                                end
                                valid = true;
                            end
                        
                            %an if/elseif statement is used to check if the
                            %game has been won by a certain user using the
                            %matrix
                            if (TTT(1,1)==1&&TTT(1,2)==1&&TTT(1,3)==1 || TTT(2,1)==1&&...
                            TTT(2,2)==1&& TTT(2,3)==1 || TTT(3,1)==1&&TTT(3,2)==1&&TTT(3,3)==1 ||...
                            TTT(1,1)==1&&TTT(2,1)==1&&TTT(3,1)==1 || TTT(1,2)==1&&TTT(2,2)==1&&TTT(3,2)==1 ...
                            || TTT(1,3)==1&&TTT(2,3)==1&&TTT(3,3)==1 || TTT(1,1)==1&&TTT(2,2)==1&&TTT(3,3)==1 ...
                            || TTT(1,3)==1&&TTT(2,2)==1&&TTT(3,1)==1)

                                win = 1;

                            elseif (TTT(1,1)==2&&TTT(1,2)==2&&TTT(1,3)==2 || TTT(2,1)==2&& TTT(2,2)==2&&...
                             TTT(2,3)==2 || TTT(3,1)==2&&TTT(3,2)==2&&TTT(3,3)==2 || TTT(1,1)==2&&TTT(2,1)==2&&...
                             TTT(3,1)==2 || TTT(1,2)==2&&TTT(2,2)==2&&TTT(3,2)==2 || TTT(1,3)==2&&TTT(2,3)==2&&...
                             TTT(3,3)==2 || TTT(1,1)==2&&TTT(2,2)==2&&TTT(3,3)==2 || TTT(1,3)==2&&TTT(2,2)==2&&TTT(3,1)==2)
                        
                                win = 2;

                            else
                                win = 0;
                            end
                            
                            %if the game was won by Xs, it displays that
                            %the game has been won by Player A and advances
                            %all the turns to exit out of the loop
                            if (win == 1)
                                app.WinnerLabel.Text = "Won by Player A!";
                                turns = turns + 6;
                            end    
                        end
                    
                    % elseif player b is the one to go second and the remainder is even,
                    % all the lines under the if statement are run through    
                    elseif r == 0 && playerbfirst == 0
                        %sets a variable named valid to false for a while loop
                        valid = false;
                        while valid == false
                        %turns off the red light and turns on the blue
                        %light to indicate it is Os turn and variables for the input
                        %of row and column are created
                            app.aBoard.writeDigitalPin('D13',0);
                            app.aBoard.writeDigitalPin('D12',1);
                            row = app.WhichRowEditField.Value;
                            col = app.WhichColumnEditField.Value;
                            
                            %same function as code above
                            if (col== "A")
                                acol = 1;
                            elseif (col == "B")
                                acol = 2;
                            elseif (col == "C")    
                                acol = 3;
                            end
                            
                            %same function as code above
                            if (row>3||row<1||acol>3||acol<1||TTT(row,acol)==1||TTT(row,acol)==2)
                                check = 1;
                            else
                                check = 0;
                            end
                               %same function as code above
                               while (readDigitalPin(app.aBoard, 'D6') == 1)
                                   if (readDigitalPin(app.aBoard, 'D6') == 0)
                                       break;
                                   end
                               end
                            
                            %same function as code above
                            if (check == 1)
                                app.InvalidLabel.Text = "Invalid?: Yes, try again";
                                valid = false;
                            
                            %else, it shows that the spot was not invalid, sets the spot on the matrix to 2, and it plots the O 
                            %according to whatever spot the user chose and sets valid as true to break out of the player loop    
                            else
                                app.InvalidLabel.Text = "Invalid?: No, next turn";
                                TTT(row,acol)=2;
                                if (row == 1 && acol == 1)
                                    app.A1Label.Text = "O";
                                elseif (row == 1 && acol == 2)
                                    app.B1Label.Text = "O";
                                elseif (row == 1 && acol == 3)
                                    app.C1Label.Text = "O";
                                elseif (row == 2 && acol == 1)
                                    app.A2Label.Text = "O";
                                elseif (row == 2 && acol == 2)
                                    app.B2Label.Text = "O";
                                elseif (row == 2 && acol == 3)
                                    app.C2Label.Text = "O";
                                elseif (row == 3 && acol == 1)
                                    app.A3Label.Text = "O";     
                                elseif (row == 3 && acol == 2)
                                    app.B3Label.Text = "O";    
                                elseif (row == 3 && acol == 3)
                                    app.C3Label.Text = "O";    
                                end
                                valid = true;
                            end
                        
                            %same function as code above
                            if (TTT(1,1)==1&&TTT(1,2)==1&&TTT(1,3)==1 || TTT(2,1)==1&&...
                            TTT(2,2)==1&& TTT(2,3)==1 || TTT(3,1)==1&&TTT(3,2)==1&&TTT(3,3)==1 ||...
                            TTT(1,1)==1&&TTT(2,1)==1&&TTT(3,1)==1 || TTT(1,2)==1&&TTT(2,2)==1&&TTT(3,2)==1 ...
                            || TTT(1,3)==1&&TTT(2,3)==1&&TTT(3,3)==1 || TTT(1,1)==1&&TTT(2,2)==1&&TTT(3,3)==1 ...
                            || TTT(1,3)==1&&TTT(2,2)==1&&TTT(3,1)==1)

                                win = 1;

                            elseif (TTT(1,1)==2&&TTT(1,2)==2&&TTT(1,3)==2 || TTT(2,1)==2&& TTT(2,2)==2&&...
                             TTT(2,3)==2 || TTT(3,1)==2&&TTT(3,2)==2&&TTT(3,3)==2 || TTT(1,1)==2&&TTT(2,1)==2&&...
                             TTT(3,1)==2 || TTT(1,2)==2&&TTT(2,2)==2&&TTT(3,2)==2 || TTT(1,3)==2&&TTT(2,3)==2&&...
                             TTT(3,3)==2 || TTT(1,1)==2&&TTT(2,2)==2&&TTT(3,3)==2 || TTT(1,3)==2&&TTT(2,2)==2&&TTT(3,1)==2)
                        
                                win = 2;

                            else
                                win = 0;
                            end
                            
                            %if the game was won by Os, it displays that
                            %the game has been won by Player B and advances
                            %all the turns to exit out of the loop
                            if (win == 2)
                                app.WinnerLabel.Text = "Won by Player B!";
                                turns = turns + 6;
                            end    
                        end
                    
                    % if player b is the one to go first and the remainder is odd,
                    % all the lines under the if statement are run through    
                    elseif r == 1 && playerbfirst == 1
                        %sets a variable named valid to false for a while loop
                        valid = false;
                        while valid == false
                        %turns off the blue light and turns on the red
                        %light to indicate it is Xs turn and variables for the input
                        %of row and column are created
                            app.aBoard.writeDigitalPin('D12',0);
                            app.aBoard.writeDigitalPin('D13',1);
                            row = app.WhichRowEditField.Value;
                            col = app.WhichColumnEditField.Value;
                                
                            %same function as code above
                            if (col== "A")
                                acol = 1;
                            elseif (col == "B")
                                acol = 2;
                            elseif (col == "C")    
                                acol = 3;
                            end
                            
                            %same function as code above
                            if (row>3||row<1||acol>3||acol<1||TTT(row,acol)==1||TTT(row,acol)==2)
                                check = 1;
                            else
                                check = 0;
                            end
                               %same function as code above
                               while (readDigitalPin(app.aBoard, 'D6') == 1)
                                   if (readDigitalPin(app.aBoard, 'D6') == 0)
                                       break;
                                   end
                               end
                            
                            %same function as code above
                            if (check == 1)
                                app.InvalidLabel.Text = "Invalid?: Yes, try again";
                                valid = false;
                            %same function as code above    
                            else
                                app.InvalidLabel.Text = "Invalid?: No, next turn";
                                TTT(row,acol)=1;
                                if (row == 1 && acol == 1)
                                    app.A1Label.Text = "X";
                                elseif (row == 1 && acol == 2)
                                    app.B1Label.Text = "X";
                                elseif (row == 1 && acol == 3)
                                    app.C1Label.Text = "X";
                                elseif (row == 2 && acol == 1)
                                    app.A2Label.Text = "X";
                                elseif (row == 2 && acol == 2)
                                    app.B2Label.Text = "X";
                                elseif (row == 2 && acol == 3)
                                    app.C2Label.Text = "X";
                                elseif (row == 3 && acol == 1)
                                    app.A3Label.Text = "X";     
                                elseif (row == 3 && acol == 2)
                                    app.B3Label.Text = "X";    
                                elseif (row == 3 && acol == 3)
                                    app.C3Label.Text = "X";    
                                end
                                valid = true;
                            end
                        
                            %same function as code above
                            if (TTT(1,1)==1&&TTT(1,2)==1&&TTT(1,3)==1 || TTT(2,1)==1&&...
                            TTT(2,2)==1&& TTT(2,3)==1 || TTT(3,1)==1&&TTT(3,2)==1&&TTT(3,3)==1 ||...
                            TTT(1,1)==1&&TTT(2,1)==1&&TTT(3,1)==1 || TTT(1,2)==1&&TTT(2,2)==1&&TTT(3,2)==1 ...
                            || TTT(1,3)==1&&TTT(2,3)==1&&TTT(3,3)==1 || TTT(1,1)==1&&TTT(2,2)==1&&TTT(3,3)==1 ...
                            || TTT(1,3)==1&&TTT(2,2)==1&&TTT(3,1)==1)

                                win = 1;

                            elseif (TTT(1,1)==2&&TTT(1,2)==2&&TTT(1,3)==2 || TTT(2,1)==2&& TTT(2,2)==2&&...
                             TTT(2,3)==2 || TTT(3,1)==2&&TTT(3,2)==2&&TTT(3,3)==2 || TTT(1,1)==2&&TTT(2,1)==2&&...
                             TTT(3,1)==2 || TTT(1,2)==2&&TTT(2,2)==2&&TTT(3,2)==2 || TTT(1,3)==2&&TTT(2,3)==2&&...
                             TTT(3,3)==2 || TTT(1,1)==2&&TTT(2,2)==2&&TTT(3,3)==2 || TTT(1,3)==2&&TTT(2,2)==2&&TTT(3,1)==2)
                        
                                win = 2;

                            else
                                win = 0;
                            end
                            
                            %if the game was won by Xs, it displays that
                            %the game has been won by Player B and advances
                            %all the turns to exit out of the loop
                            if (win == 1)
                                app.WinnerLabel.Text = "Won by Player B!";
                                turns = turns + 6;
                            end    
                        end
                    
                    % if player a is the one to go second and the remainder is even,
                    % all the lines under the if statement are run through    
                    elseif r == 0 && playerafirst == 0
                        %sets a variable named valid to false for a while loop
                        valid = false;
                        while valid == false
                        %turns off the red light and blue on the red
                        %light to indicate it is Os turn and variables for the input
                        %of row and column are created
                            app.aBoard.writeDigitalPin('D13',0);
                            app.aBoard.writeDigitalPin('D12',1);
                            row = app.WhichRowEditField.Value;
                            col = app.WhichColumnEditField.Value;

                            %same function as code above
                            if (col== "A")
                                acol = 1;
                            elseif (col == "B")
                                acol = 2;
                            elseif (col == "C")    
                                acol = 3;
                            end
                        
                            %same function as code above
                            if (row>3||row<1||acol>3||acol<1||TTT(row,acol)==1||TTT(row,acol)==2)
                                check = 1;
                            else
                                check = 0;
                            end
                            
                               %same function as code above
                               while (readDigitalPin(app.aBoard, 'D6') == 1)
                                   if (readDigitalPin(app.aBoard, 'D6') == 0)
                                       break;
                                   end
                               end
                            
                            %same function as code above
                            if (check == 1)
                                app.InvalidLabel.Text = "Invalid?: Yes, try again";
                                valid = false;
                            
                            %same function as code above    
                            else
                                app.InvalidLabel.Text = "Invalid?: No, next turn";
                                TTT(row,acol)=2;
                                if (row == 1 && acol == 1)
                                    app.A1Label.Text = "O";
                                elseif (row == 1 && acol == 2)
                                    app.B1Label.Text = "O";
                                elseif (row == 1 && acol == 3)
                                    app.C1Label.Text = "O";
                                elseif (row == 2 && acol == 1)
                                    app.A2Label.Text = "O";
                                elseif (row == 2 && acol == 2)
                                    app.B2Label.Text = "O";
                                elseif (row == 2 && acol == 3)
                                    app.C2Label.Text = "O";
                                elseif (row == 3 && acol == 1)
                                    app.A3Label.Text = "O";     
                                elseif (row == 3 && acol == 2)
                                    app.B3Label.Text = "O";    
                                elseif (row == 3 && acol == 3)
                                    app.C3Label.Text = "O";    
                                end
                                valid = true;
                            end
                        
                            %same function as code above
                            if (TTT(1,1)==1&&TTT(1,2)==1&&TTT(1,3)==1 || TTT(2,1)==1&&...
                            TTT(2,2)==1&& TTT(2,3)==1 || TTT(3,1)==1&&TTT(3,2)==1&&TTT(3,3)==1 ||...
                            TTT(1,1)==1&&TTT(2,1)==1&&TTT(3,1)==1 || TTT(1,2)==1&&TTT(2,2)==1&&TTT(3,2)==1 ...
                            || TTT(1,3)==1&&TTT(2,3)==1&&TTT(3,3)==1 || TTT(1,1)==1&&TTT(2,2)==1&&TTT(3,3)==1 ...
                            || TTT(1,3)==1&&TTT(2,2)==1&&TTT(3,1)==1)

                                win = 1;
                                
                            elseif (TTT(1,1)==2&&TTT(1,2)==2&&TTT(1,3)==2 || TTT(2,1)==2&& TTT(2,2)==2&&...
                             TTT(2,3)==2 || TTT(3,1)==2&&TTT(3,2)==2&&TTT(3,3)==2 || TTT(1,1)==2&&TTT(2,1)==2&&...
                             TTT(3,1)==2 || TTT(1,2)==2&&TTT(2,2)==2&&TTT(3,2)==2 || TTT(1,3)==2&&TTT(2,3)==2&&...
                             TTT(3,3)==2 || TTT(1,1)==2&&TTT(2,2)==2&&TTT(3,3)==2 || TTT(1,3)==2&&TTT(2,2)==2&&TTT(3,1)==2)
                        
                                win = 2;

                            else
                                win = 0;
                            end
                            
                            %if the game was won by Os, it displays that
                            %the game has been won by Player A and advances
                            %all the turns to exit out of the loop
                            if (win == 2)
                                app.WinnerLabel.Text = "Won by Player A!";
                                turns = turns + 6;
                            end    
                        end    
                    end
                    % a turn counter is created to proceed the game
                    turns = turns + 1;
                end
                %sets win as equal to 1 to break out of the loop
                win = 1;
            end
           %if the sum of the entire matrix is equal 13 (indicating entire matrix is full)
           %it will display that the game has ended in a tie
           if sum(TTT(1,:))+sum(TTT(2,:))+sum(TTT(3,:))==13
               app.WinnerLabel.Text = "Ended in a tie.";
           end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 761 530];
            app.UIFigure.Name = 'UI Figure';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ScaleMethod = 'stretch';
            app.Image.Position = [56 1 373 359];
            app.Image.ImageSource = 'tictactoe.jpg';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.FontSize = 70;
            app.Label.Position = [11 259 46 114];
            app.Label.Text = '1';

            % Create Label_2
            app.Label_2 = uilabel(app.UIFigure);
            app.Label_2.FontSize = 70;
            app.Label_2.Position = [11 123 46 114];
            app.Label_2.Text = '2';

            % Create Label_3
            app.Label_3 = uilabel(app.UIFigure);
            app.Label_3.FontSize = 70;
            app.Label_3.Position = [11 1 46 114];
            app.Label_3.Text = '3';

            % Create ALabel
            app.ALabel = uilabel(app.UIFigure);
            app.ALabel.FontSize = 60;
            app.ALabel.Position = [91 363 52 93];
            app.ALabel.Text = 'A';

            % Create BLabel
            app.BLabel = uilabel(app.UIFigure);
            app.BLabel.FontSize = 60;
            app.BLabel.Position = [217 371 52 76];
            app.BLabel.Text = 'B';

            % Create CLabel
            app.CLabel = uilabel(app.UIFigure);
            app.CLabel.FontSize = 60;
            app.CLabel.Position = [345 363 56 93];
            app.CLabel.Text = 'C';

            % Create PlayerAHeadsorTailsEditFieldLabel
            app.PlayerAHeadsorTailsEditFieldLabel = uilabel(app.UIFigure);
            app.PlayerAHeadsorTailsEditFieldLabel.HorizontalAlignment = 'right';
            app.PlayerAHeadsorTailsEditFieldLabel.FontSize = 15;
            app.PlayerAHeadsorTailsEditFieldLabel.Position = [446 448 174 22];
            app.PlayerAHeadsorTailsEditFieldLabel.Text = 'Player A: Heads or Tails?';

            % Create PlayerAHeadsorTailsEditField
            app.PlayerAHeadsorTailsEditField = uieditfield(app.UIFigure, 'text');
            app.PlayerAHeadsorTailsEditField.Position = [630 446 76 22];

            % Create STARTGAMEButton
            app.STARTGAMEButton = uibutton(app.UIFigure, 'push');
            app.STARTGAMEButton.ButtonPushedFcn = createCallbackFcn(app, @STARTGAMEButtonPushed, true);
            app.STARTGAMEButton.FontSize = 15;
            app.STARTGAMEButton.Position = [476 384 202 50];
            app.STARTGAMEButton.Text = 'START GAME';

            % Create TicTacToeLabel
            app.TicTacToeLabel = uilabel(app.UIFigure);
            app.TicTacToeLabel.HorizontalAlignment = 'center';
            app.TicTacToeLabel.FontSize = 55;
            app.TicTacToeLabel.Position = [101 446 285 68];
            app.TicTacToeLabel.Text = 'Tic Tac Toe';

            % Create LandedonLabel
            app.LandedonLabel = uilabel(app.UIFigure);
            app.LandedonLabel.FontSize = 20;
            app.LandedonLabel.Position = [444 328 258 55];
            app.LandedonLabel.Text = 'Landed on';

            % Create XsandRedareLabel
            app.XsandRedareLabel = uilabel(app.UIFigure);
            app.XsandRedareLabel.FontSize = 20;
            app.XsandRedareLabel.Position = [444 312 251 25];
            app.XsandRedareLabel.Text = 'Xs and Red are';

            % Create OsandBlueareLabel
            app.OsandBlueareLabel = uilabel(app.UIFigure);
            app.OsandBlueareLabel.FontSize = 20;
            app.OsandBlueareLabel.Position = [445 279 250 25];
            app.OsandBlueareLabel.Text = 'Os and Blue are';

            % Create ThecorrespondinglightLabel
            app.ThecorrespondinglightLabel = uilabel(app.UIFigure);
            app.ThecorrespondinglightLabel.FontSize = 20;
            app.ThecorrespondinglightLabel.Position = [445 245 216 25];
            app.ThecorrespondinglightLabel.Text = 'The corresponding light';

            % Create onthebreadboardshowsLabel
            app.onthebreadboardshowsLabel = uilabel(app.UIFigure);
            app.onthebreadboardshowsLabel.FontSize = 20;
            app.onthebreadboardshowsLabel.Position = [445 221 233 25];
            app.onthebreadboardshowsLabel.Text = 'on the breadboard shows';

            % Create whosturnitisLabel
            app.whosturnitisLabel = uilabel(app.UIFigure);
            app.whosturnitisLabel.FontSize = 20;
            app.whosturnitisLabel.Position = [445 197 137 25];
            app.whosturnitisLabel.Text = 'who''s turn it is.';

            % Create GamehasbeenLabel
            app.GamehasbeenLabel = uilabel(app.UIFigure);
            app.GamehasbeenLabel.FontSize = 25;
            app.GamehasbeenLabel.Position = [436 38 194 40];
            app.GamehasbeenLabel.Text = 'Game has been:';

            % Create WinnerLabel
            app.WinnerLabel = uilabel(app.UIFigure);
            app.WinnerLabel.FontSize = 30;
            app.WinnerLabel.Position = [436 3 259 43];
            app.WinnerLabel.Text = '';

            % Create PressbuttononbreadboardtoconfirmLabel
            app.PressbuttononbreadboardtoconfirmLabel = uilabel(app.UIFigure);
            app.PressbuttononbreadboardtoconfirmLabel.FontSize = 18;
            app.PressbuttononbreadboardtoconfirmLabel.Position = [436 114 332 24];
            app.PressbuttononbreadboardtoconfirmLabel.Text = 'Press button on breadboard to confirm ';

            % Create WhichRowEditFieldLabel
            app.WhichRowEditFieldLabel = uilabel(app.UIFigure);
            app.WhichRowEditFieldLabel.HorizontalAlignment = 'right';
            app.WhichRowEditFieldLabel.FontSize = 18;
            app.WhichRowEditFieldLabel.Position = [446 169 107 22];
            app.WhichRowEditFieldLabel.Text = 'Which Row?';

            % Create WhichRowEditField
            app.WhichRowEditField = uieditfield(app.UIFigure, 'numeric');
            app.WhichRowEditField.Position = [592 169 109 22];

            % Create WhichColumnEditFieldLabel
            app.WhichColumnEditFieldLabel = uilabel(app.UIFigure);
            app.WhichColumnEditFieldLabel.HorizontalAlignment = 'right';
            app.WhichColumnEditFieldLabel.FontSize = 18;
            app.WhichColumnEditFieldLabel.Position = [445 147 132 22];
            app.WhichColumnEditFieldLabel.Text = 'Which Column?';

            % Create WhichColumnEditField
            app.WhichColumnEditField = uieditfield(app.UIFigure, 'text');
            app.WhichColumnEditField.Position = [592 147 109 22];

            % Create A1Label
            app.A1Label = uilabel(app.UIFigure);
            app.A1Label.HorizontalAlignment = 'center';
            app.A1Label.FontSize = 100;
            app.A1Label.Position = [56 236 122 124];
            app.A1Label.Text = '';

            % Create B1Label
            app.B1Label = uilabel(app.UIFigure);
            app.B1Label.HorizontalAlignment = 'center';
            app.B1Label.FontSize = 100;
            app.B1Label.Position = [182 236 122 124];
            app.B1Label.Text = '';

            % Create C1Label
            app.C1Label = uilabel(app.UIFigure);
            app.C1Label.HorizontalAlignment = 'center';
            app.C1Label.FontSize = 100;
            app.C1Label.Position = [303 236 122 124];
            app.C1Label.Text = '';

            % Create C2Label
            app.C2Label = uilabel(app.UIFigure);
            app.C2Label.HorizontalAlignment = 'center';
            app.C2Label.FontSize = 100;
            app.C2Label.Position = [303 118 122 119];
            app.C2Label.Text = '';

            % Create B2Label
            app.B2Label = uilabel(app.UIFigure);
            app.B2Label.HorizontalAlignment = 'center';
            app.B2Label.FontSize = 100;
            app.B2Label.Position = [183 118 122 119];
            app.B2Label.Text = '';

            % Create A2Label
            app.A2Label = uilabel(app.UIFigure);
            app.A2Label.HorizontalAlignment = 'center';
            app.A2Label.FontSize = 100;
            app.A2Label.Position = [56 118 122 119];
            app.A2Label.Text = '';

            % Create A3Label
            app.A3Label = uilabel(app.UIFigure);
            app.A3Label.HorizontalAlignment = 'center';
            app.A3Label.FontSize = 100;
            app.A3Label.Position = [56 0 122 119];
            app.A3Label.Text = '';

            % Create B3Label
            app.B3Label = uilabel(app.UIFigure);
            app.B3Label.HorizontalAlignment = 'center';
            app.B3Label.FontSize = 100;
            app.B3Label.Position = [182 3 122 116];
            app.B3Label.Text = '';

            % Create C3Label
            app.C3Label = uilabel(app.UIFigure);
            app.C3Label.HorizontalAlignment = 'center';
            app.C3Label.FontSize = 100;
            app.C3Label.Position = [307 0 122 119];
            app.C3Label.Text = '';

            % Create InvalidLabel
            app.InvalidLabel = uilabel(app.UIFigure);
            app.InvalidLabel.FontSize = 27;
            app.InvalidLabel.Position = [436 77 307 34];
            app.InvalidLabel.Text = 'Invalid?:';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Khanna_SF4_2_code

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end