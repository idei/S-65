import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  phpContent: string = '';

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    // Realizar una solicitud HTTP para obtener el contenido de home.php desde el servidor
    this.http.get('/assets/home.php', { responseType: 'text' }).subscribe((data: string) => {
      this.phpContent = data;
      //console.log('Contenido de phpContent:', this.phpContent);
    });
  }
}

