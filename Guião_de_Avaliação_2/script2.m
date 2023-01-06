
clc;
%this works - menu
input_id = ("Insert User ID (1 to 943):" );
user_id = input(input_id);

while (user_id < 1 || user_id > 943)
    printf("ERROR: Invalid user! Try another one");
    another_input_id = ("Insert User ID (1 to 943):" );
    user_id = input(another_input_id);
end

movies_seen = movies{user_id}; % movies from current user
[n,m] = size(movies_seen);

choice = 0;
while choice~=5 || choice>5 || choice<1
    fprintf("\n1 - Your Movies \n2 - Suggestion of movies based on other users \n3 - Suggestion of movies based on already evaluated movies \n4 - Movies feedback based on popularity \n5 - Exit")
    input_choice = ("\n Select a choice:");
    choice = input(input_choice);
    
    if (choice > 5 || choice < 1)
        fprintf("ERROR: Invalid choice! Try another one");
        fprintf("\n");
    end

    switch (choice)
    
        case 1
            for i = 1:n
                movie_id = movies_seen(i);
                movie_info =  dic{movie_id, 1};
                movie_title = extractBefore(movie_info,'(');
                fprintf("%d : %s \n", movie_id, movie_title);
            end

        case 2

            [m, n] = size(minHashTableUsers);
                distance_users = zeros(m, 2);
                for i = 1:m
                        distance_users(i,1) = sum(minHashTableUsers(user_id,:) ~= minHashTableUsers(i,:)) / n;
                        distance_users(i,2) = i;
                end

                distance_users_sorted = sortrows(distance_users, 1);
                u1 = distance_users_sorted(2,2); % (1,1) é o proprio user
                u2 = distance_users_sorted(3,2);
                u1_movies = movies{u1};
                u2_movies = movies{u2};
                k = 1;
                movies_u1_u2 = union(u1_movies,u2_movies);
                for i = 1:length(movies_u1_u2)
                    if ismember(movies_u1_u2(i,1), movies_seen) == 0
                        show_movies(k,1) = movies_u1_u2(i);
                        k = k + 1;
                    end
                end
                
                fprintf("Movie suggestions based on top 2 similar users: \n")
                for j = 1:show_movies
                    fprintf("Movie: %s \n",titles{j});
                end

        case 3
    
        case 4
    
        otherwise
    end        
end

