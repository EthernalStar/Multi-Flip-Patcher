unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ClipBrd, Unit2, LCLIntf, Grids, Buttons, ComCtrls, FileUtil, Process, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox6: TCheckBox;
    CheckGroup1: TCheckGroup;
    ComboBox1: TComboBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    SaveDialog1: TSaveDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    StringGrid1: TStringGrid;
    TrayIcon1: TTrayIcon;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure ResetSelection;
    function CalcCRC32(Path: String = ''): String;
  private

  public

  end;

var
  Form1: TForm1;
  Default_List: TStringList;  //List of Paths to the Default ROMs
  Patch_List: TStringList;  //List of Paths to the Patches
  ROM_File: String = '';  //Path to ROM File to Patch
  CURRENT_DIR: String = '';  //Place of the ROM Files or Patches to be saved
  Settings: TIniFile;  //Settings ini File

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.CalcCRC32(Path: String): String;  //Calculate the CRC32 Checksum of a given File and output the Hex String
var
  Stream: TFileStream = Nil;  //File Stream
  CRC32: LongWord = $FFFFFFFF;  //Value of the CRC32 Hash
  i: LongWord = 0;  //Temporary counter Variable
  Following: LongWord = 0;  //Used for keeping Track of Data
  Current: LongWord = 0;  //Used for keeping Track of Data
  Buffer: Array [0 .. 1024 * 1024] of Byte;  //Buffer to load File into
const
  crctable: array [0 .. 255] of LongWord = ($00000000, $77073096, $EE0E612C,
    $990951BA, $076DC419, $706AF48F, $E963A535, $9E6495A3, $0EDB8832, $79DCB8A4,
    $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91, $1DB71064,
    $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63,
    $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447,
    $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3,
    $45DF5C75, $DCD60DCF, $ABD13D59, $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F, $2802B89E, $5F058808, $C60CD9B2,
    $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D, $76DC4190, $01DB7106,
    $98D220BC, $EFD5102A, $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433, $7807C9A2,
    $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1,
    $F50FC457, $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49,
    $8CD37CF3, $FBD44C65, $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541,
    $3DD895D7, $A4D1C46D, $D3D6F4FB, $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9, $5005713C, $270241AA, $BE0B1010,
    $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F, $5EDEF90E, $29D9C998,
    $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD, $EDB88320,
    $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $0A00AE27,
    $7D079EB1, $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB,
    $196C3671, $6E6B06E7, $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F,
    $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B, $D80D2BDA, $AF0A1B4C, $36034AF6,
    $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79, $CB61B38C, $BC66831A,
    $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F, $C5BA3BBE,
    $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9, $EB0E363F, $72076785,
    $05005713, $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38, $92D28E9B, $E5D5BE0D,
    $7CDCEFB7, $0BDBDF21, $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD,
    $F6B9265B, $6FB077E1, $18B74777, $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45, $A00AE278, $D70DD2EE, $4E048354,
    $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB, $AED16A4A, $D9D65ADC,
    $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9, $BDBDF21C,
    $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B,
    $2D02EF8D);  //Table used for CRC32 Calculation | See "https://www.mrob.com/pub/comp/crc-all.html" for more Information
begin
  Result := '00000000';  //Initialize Result

  Stream := TFileStream.Create(Path, fmOpenRead OR fmShareDenyNone);  //Ctreate File Stream without Locking the File
  Current := Stream.Size;  //Set Data Position

  repeat  //Loop

    if Current < SizeOf(Buffer) then begin

      Following := Current  //Calculate Next Position

    end else
    begin

      Following := SizeOf(Buffer);  //Calculate Next Position

    end;

    Current := Current - Following;  //Calculate Next Position
    Stream.ReadBuffer(Buffer, Following);  //Read from FileStream

    for i := 0 to (Following - 1) do begin  //Iterate through the Bytes

      CRC32 := CRCTable[Byte(CRC32 XOR LongWord(Buffer[i]))] XOR ((CRC32 SHR 8) AND $00FFFFFF);  //Calculate CRC32 with Table

    end;

  until (Current <= 0);  //Stop when File done

  FreeAndNil(Stream);  //Free FileStream

  Result := IntToHex(NOT CRC32, 8);  //Get Result CRC32 Hash as Hex String

end;


procedure TForm1.ResetSelection;  //Reset after Changing some Settings
begin
  StringGrid1.Clear;  //Clear StringGrid

  StringGrid1.ColCount := 3;  //Set Col Count
  StringGrid1.RowCount := 1;  //Set Row Count

  StringGrid1.ColWidths[0] := 475;  //Set Cols Size
  StringGrid1.ColWidths[1] := 100;   //Set Cols Size
  StringGrid1.ColWidths[2] := 70;  //Set Cols Size

  StringGrid1.Cells[0,0] := 'Pach Name';  //Set Cells Name
  StringGrid1.Cells[1,0] := 'Status';  //Set Cells Name
  StringGrid1.Cells[2,0] := 'Checksum';  //Set Cells Name

  Label1.Caption := IntToStr(StringGrid1.RowCount - 1);  //Display Item Number in ListBox

  CURRENT_DIR := '';
end;

procedure TForm1.Image1Click(Sender: TObject);  //Logo Click
var
  PopupForm: TForm2;  //Set new Form as About Form
begin

  PopupForm := TForm2.Create(nil);  //Create the Form

  try

    PopupForm.ShowModal; // Show Form2 as a modal dialog

  finally

    PopupForm.Free;  //Free the Form

  end;

end;

procedure TForm1.Image2Click(Sender: TObject);  //Delete single Entry from List
begin

  if StringGrid1.Row > 0 then begin  //Check if something is selected

    StringGrid1.DeleteRow(StringGrid1.Row);  //Delete Single Row
    Label1.Caption := IntToStr(StringGrid1.RowCount - 1);  //Display Item Number in ListBox

  end;

end;

procedure TForm1.Image3Click(Sender: TObject);  //Reset List
begin

  StringGrid1.Clear;  //Clear StringGrid

  StringGrid1.ColCount := 3;  //Set Col Count
  StringGrid1.RowCount := 1;  //Set Row Count

  StringGrid1.ColWidths[0] := 475;  //Set Cols Size
  StringGrid1.ColWidths[1] := 100;   //Set Cols Size
  StringGrid1.ColWidths[2] := 70;  //Set Cols Size

  StringGrid1.Cells[0,0] := 'Pach Name';  //Set Cells Name
  StringGrid1.Cells[1,0] := 'Status';  //Set Cells Name
  StringGrid1.Cells[2,0] := 'Checksum';  //Set Cells Name

  Label1.Caption := IntToStr(StringGrid1.RowCount - 1);  //Display Item Number in ListBox

end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin

  if RadioButton1.Checked then begin  //Check for Button Selection

    Button1.Caption := 'Open Patch Folder';  //Change Caption
    Button2.Caption := 'Choose File to Patch';  //Change Caption

  end
  else begin

    Button1.Caption := 'Open ROM Folder';  //Change Caption
    Button2.Caption := 'Choose a clean ROM';  //Change Caption

  end;

  ResetSelection;  //Reset due to Settings Change

end;

procedure TForm1.RadioButton3Change(Sender: TObject);
begin

  if RadioButton1.Checked then begin  //Reset only when in Apply Mode

    ResetSelection;  //Reset due to Settings Change

  end;

end;

procedure TForm1.TrayIcon1Click(Sender: TObject);  //Self Settings to Hide Application after clicking TrayIcon
begin

  Form1.Visible := NOT Form1.Visible;  //Switch Form Visibility Status

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer = 0;  //Temp Counter Variable
begin

  if NOT fileexists('MFP/Flips/flips.exe') then begin  //Check for Existance of flips.exe

    if MessageDlg('Multi Flip Patcher will not function without Floating IPS.' + LineEnding + 'Please Place a Copy of flips.exe inside MFP\Flips\' + LineEnding + 'Do you want to go to the Github Page of Floating IPS?', mtWarning, [mbYes, mbNo], 0) = mrYes then begin  //Ask to open the Floating IPS Repository

      OpenUrl('https://github.com/Alcaro/Flips');  //Open the Repository of the Floating IPS Patcher

    end;

    Halt;  //Stop further Execution

  end;

  if FileExists(ExtractFilePath(Application.ExeName) + 'Multi Flip Patcher.ini') then begin  //Check if Settings File is Present

    Settings := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Multi Flip Patcher.ini');

    try

      CheckBox1.Checked := StrToBool(Settings.ReadString('Settings', 'Skip Checksum Calculation', '0'));
      CheckBox2.Checked := StrToBool(Settings.ReadString('Settings', 'Hide Tray Icon', '0'));
      CheckBox4.Checked := StrToBool(Settings.ReadString('Settings', 'Topmost', '0'));
      CheckBox3.Checked := StrToBool(Settings.ReadString('Settings', 'Ignore Patch Checksum', '0'));
      CheckBox6.Checked := StrToBool(Settings.ReadString('Settings', 'Auto Save/Load Settings', '-1'));

      RadioButton4.Checked := StrToBool(Settings.ReadString('Settings', 'IPS Format', '0'));
      RadioButton2.Checked := StrToBool(Settings.ReadString('Settings', 'Create Mode', '0'));

    finally

      Settings.Free //Free Settings File

    end;

  end;

  Default_List := TStringList.Create;  //Create Default List
  Patch_List := TStringList.Create;  //Create Default List

  Default_List := FindAllFiles(ExtractFilePath(Application.ExeName) + 'MFP\Defaults\', '*', False);  //Fill Defaults in List

  for i := 0 to Default_List.Count - 1 do begin  //Iterate through List

    ComboBox1.Items.Add(ExtractFileName(Default_List[i]));  //Display only the Filenames in the ComboBox

  end;

  StringGrid1.ColWidths[0] := 475;  //Set Cols Size
  StringGrid1.ColWidths[1] := 100;   //Set Cols Size
  StringGrid1.ColWidths[2] := 70;  //Set Cols Size

  StringGrid1.Cells[0,0] := 'Pach Name';  //Set Cells Name
  StringGrid1.Cells[1,0] := 'Status';  //Set Cells Name
  StringGrid1.Cells[2,0] := 'Checksum';  //Set Cells Name

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer = 0;  //Temp Counter Variable
begin

  if RadioButton1.Checked then begin  //Check for Apply Mode

    SelectDirectoryDialog1.Title := 'Choose Patch Folder';

    if SelectDirectoryDialog1.Execute then begin  //Execute Directory Dialog

      StringGrid1.Clear;  //Clear StringGrid
      StringGrid1.ColCount := 3;  //Set Col Count
      StringGrid1.RowCount := 1;  //Set Row Count
      StringGrid1.ColWidths[0] := 475;  //Set Cols Size
      StringGrid1.ColWidths[1] := 100;   //Set Cols Size
      StringGrid1.ColWidths[2] := 70;  //Set Cols Size
      StringGrid1.Cells[0,0] := 'Pach Name';  //Set Cells Name
      StringGrid1.Cells[1,0] := 'Status';  //Set Cells Name
      StringGrid1.Cells[2,0] := 'Checksum';  //Set Cells Name

      Label1.Caption := IntToStr(StringGrid1.RowCount - 1);  //Display Item Number in ListBox

      if RadioButton3.Checked then begin  //Check for BPS Mode

        Patch_List := FindAllFiles(SelectDirectoryDialog1.FileName, '*.bps', False);  //Select all BPS Files

      end
      else begin

        Patch_List := FindAllFiles(SelectDirectoryDialog1.FileName, '*.ips', False);  //Select all IPS Files

      end;

      for i := 1 to Patch_List.Count do begin  //Iterate through Patch_List

        StringGrid1.RowCount := StringGrid1.RowCount + 1;  //Expand Rows Dynamically
        StringGrid1.Cells[0, i] := Patch_List[i - 1];  //Set Entry From Patch_List
        StringGrid1.Cells[1, i] := 'Not Patched';  //Initialize Status
        StringGrid1.Cells[2, i] := '00000000';  //Initialize Checksum

      end;

    end;

  end
  else begin

    SelectDirectoryDialog1.Title := 'Choose Games Folder'; 

    if SelectDirectoryDialog1.Execute then begin  //Execute Directory Dialog

      StringGrid1.Clear;  //Clear StringGrid
      StringGrid1.ColCount := 3;  //Set Col Count
      StringGrid1.RowCount := 1;  //Set Row Count
      StringGrid1.ColWidths[0] := 475;  //Set Cols Size
      StringGrid1.ColWidths[1] := 100;   //Set Cols Size
      StringGrid1.ColWidths[2] := 70;  //Set Cols Size
      StringGrid1.Cells[0,0] := 'Pach Name';  //Set Cells Name
      StringGrid1.Cells[1,0] := 'Status';  //Set Cells Name
      StringGrid1.Cells[2,0] := 'Checksum';  //Set Cells Name

      Patch_List := FindAllFiles(SelectDirectoryDialog1.FileName, '*.*', False);  //Select all Files

      for i := 1 to Patch_List.Count do begin  //Iterate through Patch_List

        StringGrid1.RowCount := StringGrid1.RowCount + 1;  //Expand Rows Dynamically
        StringGrid1.Cells[0, i] := Patch_List[i - 1];  //Set Entry From Patch_List
        StringGrid1.Cells[1, i] := 'Not Processed';  //Initialize Status
        StringGrid1.Cells[2, i] := '00000000';  //Initialize Checksum

      end;

    end;

  end;

  CURRENT_DIR := SelectDirectoryDialog1.FileName;  //Set curretn Directory

  Label1.Caption := IntToStr(StringGrid1.RowCount - 1);  //Display Item Number in ListBox

end;

procedure TForm1.BitBtn1Click(Sender: TObject);  //Patching Process
var
  i: Integer = 0;  //Temporary Counter Variable
  tf: String = '';  //Temporary String to represent the new File
begin

  ProgressBar1.Max := StringGrid1.RowCount - 1; //Set Max ProgressBar
  ProgressBar1.Position := 0;  //Reset Position

  if NOT (ROM_FILE = '') AND NOT (CURRENT_DIR = '') AND NOT (StringGrid1.RowCount <= 1) then begin

  Panel1.Enabled := False;  //Disable Panel
  Panel2.Enabled := False;  //Disable Panel

  with TProcess.Create(nil) do begin  //Create a new Process to run Flips

    tf := '';  //Reset TF

    CurrentDirectory := CURRENT_DIR;  //Set Directory
    Executable := 'MFP/Flips/flips.exe';  //Set flips.exe as executable
    Options := [poUsePipes, poWaitOnExit, poNoConsole];  //Do set the options to get the result and wait for it and also hide the console

    for i := 1 to StringGrid1.RowCount - 1 do begin  //Iterate through Rows

      Parameters.Clear;

     if RadioButton1.Checked then begin

      Parameters.Add('-a');  //Add Parameter
      if CheckBox3.Checked then begin  //Check for ignore Checksum
         Parameters.Add('--ignore-checksum');  //Add Parameter
      end;
      Parameters.Add('"' + StringGrid1.Cells[0,i] + '"');  //Add Parameter
      Parameters.Add('"' + ROM_FILE + '"');  //Add Parameter
      Parameters.Add('"' + LeftStr(StringGrid1.Cells[0,i], Length(StringGrid1.Cells[0,i]) - 4) + RightStr(ROM_FILE, 4) + '"');  //Replace Extension of Resulting File

      tf := LeftStr(StringGrid1.Cells[0,i], Length(StringGrid1.Cells[0,i]) - 4) + RightStr(ROM_FILE, 4);  //Set TF

     end else begin 

      Parameters.Add('-c');  //Add Parameter

      if RadioButton3.Checked then begin

        Parameters.Add('--bps');  //Add Parameter
      
      end
      else begin

        Parameters.Add('--ips');  //Add Parameter
      
      end;

      Parameters.Add('"' + ROM_FILE + '"');  //Add Parameter

      Parameters.Add('"' + StringGrid1.Cells[0,i] + '"');  //Add Parameter

      if RadioButton3.Checked then begin

        Parameters.Add('"' + LeftStr(StringGrid1.Cells[0,i], Length(StringGrid1.Cells[0,i]) - 4) + '.bps' + '"');  //Replace Extension of Resulting File

        tf := LeftStr(StringGrid1.Cells[0,i], Length(StringGrid1.Cells[0,i]) - 4) + '.bps';  //Set TF

      end
      else begin

        Parameters.Add('"' + LeftStr(StringGrid1.Cells[0,i], Length(StringGrid1.Cells[0,i]) - 4) + '.ips' + '"');  //Replace Extension of Resulting File

        tf := LeftStr(StringGrid1.Cells[0,i], Length(StringGrid1.Cells[0,i]) - 4) + '.ips';  //Set TF

      end;

     end;

      Execute;  //Execute Task

      ProgressBar1.Position := ProgressBar1.Position + 1;  //Increase Progress

      if ExitStatus = 0 then begin  //Check Exit Status

        StringGrid1.Cells[1,i] := 'SUCCESS';  //Print Success Message

        if NOT CheckBox1.Checked then begin  //Check for Checksum Skip

          if RadioButton1.Checked then begin  //Check for Patching mode

            StringGrid1.Cells[2,i] := CalcCRC32(tf);  //Calculate Checksum of new ROM

          end
          else begin

            StringGrid1.Cells[2,i] := CalcCRC32(StringGrid1.Cells[0,i]);  //Calculate Checksum of old ROM

          end;

        end
        else begin

          StringGrid1.Cells[2,i] := 'SKIP';  //Checksum Placeholder

        end;

      end
      else begin

        StringGrid1.Cells[1,i] := 'FAIL';  //Print Fail Message

        if NOT CheckBox1.Checked AND CheckBox3.Checked then begin  //Calculate Checksum when patch checksum skiped

          StringGrid1.Cells[2,i] := CalcCRC32(tf);  //Calculate Checksum of new Patch

        end
        else begin

          StringGrid1.Cells[2,i] := 'SKIP';  //Checksum Placeholder

        end;

      end;

    end;

    Free;  //Free the Process

  end;

  Panel1.Enabled := True;  //Disable Panel
  Panel2.Enabled := True;  //Disable Panel


  end
  else begin

    MessageDlg('There was an Error processing your Tasks.' + LineEnding + 'Maybe you did not select your Games or Patches?' , mtError, [mbOK], 0); //Display Error Message

  end;



end;

procedure TForm1.Button2Click(Sender: TObject);
begin

  if OpenDialog1.Execute = True then begin  //Check for Execution

    ComboBox1.ItemIndex := -1;  //Reset ComboBox Index
    ComboBox1.Caption := 'Default Files';  //Reset ComboBox Caption

    ROM_File := OpenDialog1.FileName;  //Set File to ROM_File

    Form1.Caption := 'Multi Flip Patcher | ROM: ' + ExtractFileName(ROM_File) + ' | CRC32: ' + CalcCRC32(ROM_File) + ' |';  //Calculate Checksum of Default file

  end;

end;

procedure TForm1.Button3Click(Sender: TObject);  //Export Chart as CSV
begin

  if SaveDialog1.Execute then begin  //Check for Save Dialog Execution

     StringGrid1.SaveToCSVFile(SaveDialog1.FileName);  //Save Chart to CSV File

  end;

end;

procedure TForm1.CheckBox2Change(Sender: TObject);  //Selft Settings to switch off TrayIcon
begin

  if CheckBox2.Checked then begin
    TrayIcon1.Visible := False;  //Hide TrayIcon
  end
  else begin
    TrayIcon1.Visible := True;  //Show TrayIcon
  end;

end;

procedure TForm1.CheckBox4Change(Sender: TObject);  //Self Settings to switch off Topmost mode
begin

  if CheckBox4.Checked then begin
    Form1.FormStyle := fsSystemStayOnTop;  //FormStyle Normal -> Application not Topmost
  end
  else begin
    Form1.FormStyle := fsNormal;  //FormStyle SystemStayOnTop -> Application Topmost
  end;

end;

procedure TForm1.CheckBox6Change(Sender: TObject);  //Auto Save/Load Settings Checkbox Change
begin

  if NOT CheckBox6.Checked then begin  //Check for disabled Saving Settings

    if FileExists(ExtractFilePath(Application.ExeName) + 'Multi Flip Patcher.ini') then begin  //Check if Settings where allready created

      if MessageDlg('Unsetting this Option will delete the Settings File.' + LineEnding + 'Do you want to continue?', mtWarning, [mbYes, mbNo], 0) = mrYes then begin  //Ask if user wnats to delete current settings

        DeleteFile(ExtractFilePath(Application.ExeName) + 'Multi Flip Patcher.ini');  //Delete the Settings File

      end
      else begin

        CheckBox6.Checked := True;  //Check Checkbox again

      end;

    end;

  end;

end;

procedure TForm1.ComboBox1Change(Sender: TObject);  //Select Default File from ComboBox
begin

  ROM_File := Default_List[ComboBox1.ItemIndex];  //Set ROM_File Path from Defaults

  Form1.Caption := 'Multi Flip Patcher | ROM: ' + ExtractFileName(ROM_File) + ' | CRC32: ' + CalcCRC32(ROM_File) + ' |';  //Calculate Checksum of Default file

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);  //Before Close
begin

  TrayIcon1.Visible := False;  //Hide TrayIcon before closing the Application to prevent Leftovers
  CanClose := True;  //Allow Closing

  if (CheckBox6.Checked = True) AND (CanClose = True) then begin

    Settings := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Multi Flip Patcher.ini');  //Create Settings File

    try

      Settings.WriteString('Settings', 'IPS Format', BoolToStr(RadioButton4.Checked));
      Settings.WriteString('Settings', 'Create Mode', BoolToStr(RadioButton2.Checked));
      Settings.WriteString('Settings', 'Topmost', BoolToStr(CheckBox4.Checked));
      Settings.WriteString('Settings', 'Hide Tray Icon', BoolToStr(CheckBox2.Checked));
      Settings.WriteString('Settings', 'Skip Checksum Calculation', BoolToStr(CheckBox1.Checked));
      Settings.WriteString('Settings', 'Ignore Patch Checksum', BoolToStr(CheckBox3.Checked));
      Settings.WriteString('Settings', 'Auto Save/Load Settings', BoolToStr(CheckBox6.Checked));

    finally

      Settings.Free;  //Free Settings File

    end;

  end;

end;

end.

