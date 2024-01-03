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
    #можно отжать и проверить что хеш дополнился новой записью
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
1;
