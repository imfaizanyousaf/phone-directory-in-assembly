include irvine32.inc
include macros.inc
bsize = 5000

.data
	file byte "contacts.txt",0
	h1 handle ?
	buffer byte bsize dup(?)
	slength dd ?
	bwritten dd ?
	count dd 0
	spacing byte "			",0
	newline byte " ",0dh,0ah,0
	buffer2 byte bsize dup(?)
	
.code
	

; MENU
	menu proc
		mWrite "0. Exit"
		call crlf
		mWrite "1. Add Contact"
		call crlf
		mWrite "2. Display All Contacts"
		call crlf
		call crlf
		mWrite "Enter choice: "
		call readint
	ret
	menu endp

; NEW COLUMN
	newcol proc
		mov edx,offset spacing
		mov ecx,2
		mov eax,h1
		call writetofile
		mov bwritten,eax
		ret
	newcol endp

	linebreak proc
		mov edx,offset newline
		mov ecx,3
		mov eax,h1
		call writetofile
		mov bwritten,eax
	ret
	linebreak endp

	main proc
		mov eax,yellow+(black*16)
		call settextcolor
		
		mov edx,offset file
		call createoutputfile
		mov h1,eax
		

		call crlf
		call crlf

		L1:
		mWrite <"************************************************************************************************",0dh,0ah>
		call crlf
		mWrite "		W E l C O M E   T O   P H O N E   D I R E C T O R Y"
		call crlf
		call crlf
		mWrite <"				- MADE BY GROUP 5 -",0dh,0ah>
		call crlf
		mWrite <"************************************************************************************************",0dh,0ah>
		call crlf


		
			call menu
			.if eax == 1
				
				call crlf
			
				mWrite "Enter Name of Contact: "
				mov edx,offset buffer
				mov ecx,bsize
				call readstring
				mov slength,eax
				mov eax,h1
				mov edx,offset buffer
				mov ecx,slength
				call writetofile
				mov bwritten, eax

				call newcol

				phone:

				mWrite "Enter Phone Number: "
				mov edx,offset buffer
				mov ecx,bsize
				call readstring
				mov slength,eax
				cmp eax,11
				je number_ok
				call crlf
				mWrite <"*********NUMBER MUST BE 11 DIGITS LONG*********",0dh,0ah>
				call crlf
				jmp phone
				number_ok:
				mov eax,h1
				mov edx,offset buffer
				mov ecx,slength
				call writetofile
				mov bwritten, eax

				call newcol

				mWrite "Enter Email: "
				mov edx,offset buffer
				mov ecx,bsize
				call readstring
				mov slength,eax
				mov eax,h1
				mov edx,offset buffer
				mov ecx,slength
				call writetofile
				mov bwritten, eax

				call newcol

				mWrite "Enter Address: "
				mov edx,offset buffer
				mov ecx,bsize
				call readstring
				mov slength,eax
				mov eax,h1
				mov edx,offset buffer
				mov ecx,slength
				call writetofile
				mov bwritten, eax

				call linebreak

				inc count
				call crlf
				call crlf

				mWrite "****************CONTACT ADDED SUCCESSFULLY****************"
				call crlf 
				call crlf
				call waitmsg
				call clrscr
				call crlf
				jmp L1
			.elseif eax==2

				call crlf
				mov eax,black+(white*16)
				call settextcolor
				mWrite "Total Contacts: "
				mov eax,count
				call writeint
				call crlf
				cmp eax,0
				je nocontact

				mov eax,yellow+(black*16)
				call settextcolor

				mov eax,h1
				call closefile

				mov edx,offset file
				call openinputfile
				mov h1,eax
				cmp eax, INVALID_HANDLE_VALUE
				jne file_ok
				mWrite <"Cannot open file",0dh,0ah>
				jmp quit

				file_ok:
					mov edx,offset buffer
					mov ecx,bsize
					call readfromfile
					jnc check_buffer_size 
					mWrite "Error reading file. " 
					call WriteWindowsMsg
					jmp close

					check_buffer_size:
					cmp eax,bsize
					jb buf_size_ok 
					mWrite <"Error: Buffer too small for the file",0dh,0ah>
					jmp close

					buf_size_ok:
					mov buffer[eax],0
					mov edx,offset buffer
					call crlf

					mWrite <"************************************************************************************",0dh,0ah>
					mWrite <"NAME		PHONE NUMBER		EMAIL			ADDRESS",0dh,0ah>
					mWrite <"************************************************************************************",0dh,0ah>
					call writestring
					call crlf
					call crlf
					call waitmsg
					call clrscr
					call crlf
					jmp L1

					nocontact:
						call crlf
						call crlf
						mov eax,yellow+(black*16)
						call settextcolor
						mWrite <"********************NO CONTACTS FOUND********************",0dh,0ah>
						call crlf
						call waitmsg
						call clrscr
						call crlf
						jmp L1

			.elseif eax==0
				jmp quit
			.endif
		close:
			mov eax,h1
			call closefile
		quit:
exit
main endp
end
