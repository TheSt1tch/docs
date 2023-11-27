# Visual Studio Code всегда запрашивает учетные данные Git

Это работало для меня:

1. Установите помощник по учетным данным для хранения:
   `git config --global credential.helper store`
2. Затем проверьте, хотите ли вы:
   `git config --global credential.helper`

Простой пример использования [Git Bash](https://superuser.com/questions/1053633/what-is-git-bash-for-windows-anyway) , приведенный [здесь](https://git-scm.com/docs/git-credential-store/1.7.12.1#_examples) (работает только для текущего репозитория, используйте `--global`для всех репозиториев):

```
git config credential.helper store
git push http://example.com/repo.git

Username: < type your username >
Password: < type your password >

[several days later]

git push http://example.com/repo.git

[your credentials are used automatically]
```

Это также будет работать для кода Visual Studio.

Более подробный пример и расширенное использование — [здесь](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage) .

**Примечание.** Имя пользователя и пароли не шифруются и хранятся в текстовом формате, поэтому используйте их только на своем персональном компьютере.
