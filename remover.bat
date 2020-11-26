@powershell -NoProfile -ExecutionPolicy Unrestricted "&([ScriptBlock]::Create((cat -encoding utf8 \"%~f0\" | ? {$_.ReadCount -gt 2}) -join \"`n\"))" %*

$key = " の競合コピー ";
# 注 このbatファイル自体も削除の対象なので、batと指定すると、このファイルも削除されます。

Write-Output ("文字列 " + $key + " を含むファイルを探します。");

$List = Get-ChildItem -Recurse * | Where-Object { ! $_.PSIsContainer };
$DeleteList = @();

foreach($_ in $List){
  if($_.Name.IndexOf($key) -gt -1){
    Write-Output ($_.FullName);
    $DeleteList += $_;
  }
}

Write-Output ("文字列 " + $key + " を含むファイルは " + $DeleteList.Length + " 個見つかりました。");

if($DeleteList.Length -eq 0){
  Read-Host "Enterキー を押下すると閉じます。";
  exit
}

$ans =(Read-Host "本当に削除していいですか？ y/n");
 
if($ans -eq "y"){
  $Count = 0;
  foreach($_ in $DeleteList){
    Write-Output ($_.FullName);
    $Count ++;
    Remove-Item $_.FullName;
  }
  Write-Output ($Count.ToString() + " 個のファイルを削除しました。");
} 

Read-Host "Enterキー を押下すると閉じます。";

#cmd /k