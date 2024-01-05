package tools;
use strict;
use warnings FATAL => 'all';

my $conf_path = '/Users/evgenijtretakov/PerlProject/tasks/tools/conf.ini';

sub read_config {
    my ( $filename ) = @_;

    my %config;#хэш для хранения значений

    if ( open my $fh, '<', $filename ) {
        while ( my $line = <$fh> ) {
            chomp $line;
            $line =~ s/\s+//g;  # заменяем пробелы на пустоту

            if ( $line =~ m/^#/ ) {  # проверяем, если строка начинается с #
                next;  # пропускаем строку
            }

            my ( $key, $value ) = split( '=', $line, 2 );# разделяем строку по символу = и сохраняем $key и $value

            if ( $key && $value ) {  # проверяем, что ключ и значение не пустые
                $config{$key} = $value; #сохраняем ключ $key и значение $value в хэше %config
            }
        }
        close $fh; #закрываем файл
    } else {
        print "Не удалось считать файл: '$filename'\n";
    }

    return %config;
}

sub login {
    my( $user_name, $password )= @_;
    my % clients = read_config( $conf_path );

    if (exists $clients{$user_name} && $clients{$user_name} eq $password ) {
        print "Добро пожаловать, $user_name!\n";
    } else {
        print "Неверный логин или пароль.\n";
        exit;
    }
}

sub reg_user{

    my( $user_name, $password )= @_;
    my % clients = read_config( $conf_path );
if( exists $clients{$user_name} ){
    print "Такой пользователь уже существует!\n";
    return %clients;
    }
    # Добавляем пользователя в хеш
    $clients{$user_name} = $password;
    #можно отжать и проверить что хеш дополнился новой записью пока тестов нету
    # foreach my $key (keys %clients) {
    #     my $value = $clients{$key};
    #     print "$key => $value\n";
    # }
    print "Пользователь $user_name успешно зарегистрирован.\n";
    return %clients;
}

sub rewrite_config {
    my ( %clients ) = @_;

    # Открытие файла для записи
    open( my $file, '>', $conf_path ) or die "Не удалось открыть файл: $!";

    # Запись содержимого хеша в файл
    foreach my $key ( keys %clients ) {
        print $file "$key = $clients{$key}\n";
    }
    # Закрытие файла
    close( $file );
}

sub del_user{
    my ( $user_name ) = @_;
    my % clients = read_config( $conf_path );
    if( exists $clients{$user_name} ){
        delete $clients{$user_name};
        rewrite_config( %clients );
        print "Пользователь $user_name удален.\n";
    }else {
        print "Пользователя с именем $user_name не существует\n";
    }
}

sub check_user_name{
    my ( $user_name ) = @_;
    if ( $user_name =~ /^[a-zA-Z][-a-zA-Z0-9_]*[a-zA-Z0-9]$/ ){
        return 1;
    }return 0;
}
#тут как-то громоздко получилось,позже переделаю или тернарный оператор или через && и unless может убрать
sub check_user_password{
    my ( $password ) = @_;
    if (length($password) < 8) {
        print "Пароль должен быть не менее 8 символов длиной.\n";
        return 0;
    }
    unless ($password =~ /^[\p{Latin}]/) {
        print "Пароль должен начинаться с латинской буквы.\n";
        return 0;
    }
    unless ($password =~ /[!@#$%^&*()]/) {
        print "Пароль должен содержать хотя бы один спецсимвол из списка !@#$%^&*().\n";
        return 0;
    }

    unless ($password =~ /[A-Z]/) {
        print "Пароль должен содержать хотя бы один символ в верхнем регистре.\n";
        return 0;
    }

    unless ($password =~ /\d/) {
        print "Пароль должен содержать хотя бы одну цифру.\n";
        return 0;
    }

    return 1;
}

sub change_password{
    my( $user_name, $password )= @_;

    #проверить существование пользователя
    login($user_name,$password);
    my % clients = read_config( $conf_path );

    #запрос нового пароля stdin
    print "введите новый пароль\n";
    chomp(my $new_password = <STDIN>);

    #валидация нового пароля
    check_user_password($new_password);

    #присвоить новый password
    $clients{$user_name} = $new_password;

    #перезаписать файл
    rewrite_config( %clients );
}

#help -h
sub help(){
    print "######################################################
#back_end.pl usage
#Тут может быть только 'log', 'reg', 'del' или 'change'.\n
# action=reg user_name=NAME user_passwd=PASSWD ./back_end.pl - registaton new user in system;
#action=log user_name=NAME user_passwd=PASSWD ./back_end.pl - login in system
#action=del user_name=NAME ./back_end.pl - remove user from system
#action=change_passwd user_name=NAME user_passwd=PASSWD ./back_end.pl - change user password
######################################################"
}
1;
