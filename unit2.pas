unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLIntf,
  ExtCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseEnter(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;
  const LICENSE = 'Multi Flip Patcher is licensed under the' + LineEnding +
                  'GNU General Public License v3.0.' + LineEnding +
                  'You should have received a copy of the ' + LineEnding +
                  'GNU General Public License' + LineEnding +
                  'along with this program.' + LineEnding +
                  'If not, see https://www.gnu.org/licenses/';  //The String used for Displaying the License Information





  const CHANGELOG = 'Version 1.0.0:' + LineEnding +
                    ' * Initial Release.';  //The String used for Displaying the latest Changelog
  const REPO_CODEBERG = 'https://codeberg.org/EthernalStar/Multi-Flip-Patcher';  //Rpository Url for Codeberg
  const REPO_GITHUB = 'https://github.com/EthernalStar/Multi-Flip-Patcher';  //Rpository Url for Github
  const APP_TITLE = 'Multi Flip Patcher';  //Title of the Application
  const APP_VERSION = '1.0.0';  //Version of the Application
  const DEV_NAME = 'EthernalStar';  //Developer Name
  const DEV_EMAIL = 'NZSoft@Protonmail.com';  //Developer Email

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Label1MouseEnter(Sender: TObject);  //Mouse enter Label
begin

  Label1.Font.Style := [fsUnderline];  //Underline the Text

end;

procedure TForm2.Label1Click(Sender: TObject);  //OnClick Event for the Email Label
begin

  OpenUrl('mailto:' + DEV_EMAIL);  //Open Email with mailto: Address

end;

procedure TForm2.Button1Click(Sender: TObject);  //Changelog Button Press
begin

  ShowMessage(CHANGELOG);  //Display latest Changelog

end;

procedure TForm2.Button2Click(Sender: TObject);  //License Button Press
begin

  ShowMessage(LICENSE);  //Display License Information

end;

procedure TForm2.FormCreate(Sender: TObject);  //Form Creation Events
begin

  Self.Caption := 'About ' + APP_TITLE;  //Set Form Caption

  Image1.Hint := 'Visit ' + REPO_CODEBERG;  //Set Repo URL as Hint
  Image2.Hint := 'Visit ' + REPO_GITHUB;  //Set Repo URL as Hint

  Label2.Caption := APP_TITLE + ' - Verison ' + APP_VERSION;  //Set App Title and Version
  Label1.Caption := DEV_EMAIL;  //Set Developer EMail
  Label3.Caption := '©' + DEV_NAME;  //Set Developer Name

end;

procedure TForm2.Image1Click(Sender: TObject);  //Click Codeberg Repo Image
begin

  OpenUrl(REPO_CODEBERG);  //Open Repository URL

end;

procedure TForm2.Image2Click(Sender: TObject);  //Click Github Repo Image
begin

  OpenUrl(REPO_GITHUB);  //Open Repository URL

end;

procedure TForm2.Label1MouseLeave(Sender: TObject);  //Mouse Leave Label
begin

  Label1.Font.Style := [];  //Remove Underlining

end;

end.

