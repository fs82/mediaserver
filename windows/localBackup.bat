@TITLE Local Backup

@SET repository=<path to repository>
@SET include=<path to include.txt>
@SET exclude=<path to exclude.txt>

@ECHO Waking up server
wol <MAC>
timeout /T 180
@ECHO Running Backup
restic -r %repository% backup --files-from %include% --exclude-file %exclude%
@IF %ERRORLEVEL% EQU 0 (
    @ECHO Cleaning up
    restic -r %repository% forget --keep-last 1 --prune
) ELSE (
    @ECHO Error occured.
    @PAUSE
)



