program ConsoleBot;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  TelegAPI.Bot,
  Rest.Json,
  TelegAPI.Receiver.Console,
  System.SysUtils,
  TelegAPI.Types,
  TelegAPI.Bot.Impl,
  TelegaPi.Exceptions;

procedure Main;
var
  LBot: ITelegramBot;
  LReceiver: TtgReceiverConsole;
  LExcp: TtgExceptionManagerConsole;
  LStop: string;
begin
  LBot := TTelegramBot.Create('YOUR_TOKEN');
  LReceiver := TtgReceiverConsole.Create(LBot);
  try
    LExcp := LBot.ExceptionManager as TtgExceptionManagerConsole;
    LExcp.OnApiException :=
      procedure(AMethod: string; AExp: EApiRequestException)
      begin
        Writeln(AExp.ToString);
      end;
    LExcp.OnGlobalException :=
      procedure(AMethod: string; AExp: Exception)
      begin
        Writeln(AExp.ToString);
      end;
    LReceiver.OnStart :=
      procedure
      begin
        Writeln('started');
      end;
    LReceiver.OnStop :=
      procedure
      begin
        Writeln('stoped');
      end;
    LReceiver.OnMessage :=
      procedure(AMessage: ITgMessage)
      begin
        Writeln(AMessage.From.ID, ': ', AMessage.Text);
        LBot.SendMessage(AMessage.From.ID, AMessage.Text);
      end;
    Writeln('Bot nick: ', LBot.GetMe.Username);
    LReceiver.IsActive := True;
    while LStop.ToLower.Trim <> 'exit' do
    begin
      Readln(LStop);
      if LStop.ToLower.Trim = 'stop' then
        LReceiver.IsActive := False
      else if LStop.ToLower.Trim = 'start' then
        LReceiver.IsActive := True;
    end;
  finally
    LReceiver.Free;
  end;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Main;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.message);
  end;

end.

